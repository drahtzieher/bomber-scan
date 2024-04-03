#!/bin/sh
echo 'Started ... reading parameters'
# Define default values for input parameters
SBOM_FILE="${INPUT_SBOM_FILE:-sbom.json}"
DATA_PROVIDER="${INPUT_DATA_PROVIDER:-ovs}"
OUTPUT_FORMAT="${INPUT_OUTPUT_FORMAT:-stdout}"
OUTPUT_FILE="${INPUT_OUTPUT_FILE:-bomber_output}"
IGNORE_FILE="${INPUT_IGNORE_FILE:-}"

# Check if SBOM file exists
if [ ! -f "$SBOM_FILE" ]; then
    echo "SBOM file '$SBOM_FILE' not found. Please make sure the file exists."
    exit 1
fi

# Construct the base command
command="bomber"
echo "Checking command parameters"
# Add the ignore file option if provided
if [ -n "$IGNORE_FILE" ]; then
    command="$command --ignore-file=$IGNORE_FILE"
    echo 'using ignore file $IGNORE_FILE'
else
    echo '--ignore-file not set, proceeding'
fi

# Add the scan command and SBOM file
command="$command scan $SBOM_FILE"
echo "SBOM file to scan: $SBOM_FILE"
# Add the data provider option if provided
if [ "$DATA_PROVIDER" != "ovs" ]; then
    case "$DATA_PROVIDER" in
        snyk)
            # Check if SNYK token is provided
            if [ -z "${{ secrets.SNYK_TOKEN }}" ]; then
                echo "SNYK token is missing. Please provide the token as a secret."
                exit 1
            fi
            command="$command --provider $DATA_PROVIDER --token=${{ secrets.SNYK_TOKEN }}"
            echo "You selected $DATA_PROVIDER as the vulnerability data provider"
            ;;
        ossindex)
            # Check if OSSIndex credentials are provided
            if [ -z "${{ secrets.OSSINDEX_USERNAME }}" ] || [ -z "${{ secrets.OSSINDEX_TOKEN }}" ]; then
                echo "OSS Index credentials are missing. Please provide the username and token as secrets."
                exit 1
            fi
            command="$command --provider $DATA_PROVIDER --username=${{ secrets.OSSINDEX_USERNAME }} --token=${{ secrets.OSSINDEX_TOKEN }}"
            echo "You selected $DATA_PROVIDER as the vulnerability data provider"
            ;;
        *)
            echo "Invalid data provider: $DATA_PROVIDER. Supported options are 'snyk' and 'ossindex'."
            exit 1
            ;;
    esac
else
  echo "Using OVS as the data provider"
fi


# Add the output format option
command="$command --output=$OUTPUT_FORMAT"
echo "Preparing output as $OUTPUT_FORMAT"
# Add the output file option if provided
if [ -n "$OUTPUT_FILE" ] && [ "$OUTPUT_FORMAT" != "stdout" ]; then
    command="$command > $OUTPUT_FILE"
    echo "Output will be saved to $OUTPUT_FILE"
fi

# Execute the constructed command
sh -c "$command"
