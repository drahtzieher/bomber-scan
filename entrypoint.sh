#!/bin/sh

# Define default values for input parameters
SBOM_FILE="${INPUT_SBOM_FILE:-sbom.json}"
DATA_PROVIDER="${INPUT_DATA_PROVIDER:-ovs}"
OUTPUT_FORMAT="${INPUT_OUTPUT_FORMAT:-stdout}"
OUTPUT_FILE="${INPUT_OUTPUT_FILE:-bomber_output}"
IGNORE_FILE="${INPUT_IGNORE_FILE:-}"

# Construct the base command
command="bomber"

# Add the ignore file option if provided
if [ -n "$IGNORE_FILE" ]; then
    command+=" --ignore-file=$IGNORE_FILE"
fi

# Add the scan command and SBOM file
command+=" scan $SBOM_FILE"

# Add the data provider option if provided
if [ "$DATA_PROVIDER" != "ovs" ]; then
    command+=" --provider $DATA_PROVIDER"
fi

# Add credentials if required by the data provider
case "$DATA_PROVIDER" in
    snyk)
        command+=" --username=${{ secrets.SNYK_USERNAME }} --token=${{ secrets.SNYK_TOKEN }}"
        ;;
    ossindex)
        command+=" --username=${{ secrets.OSSINDEX_USERNAME }} --token=${{ secrets.OSSINDEX_TOKEN }}"
        ;;
esac

# Add the output format option
command+=" --output $OUTPUT_FORMAT"

# Add the output file option if provided
if [ -n "$OUTPUT_FILE" ] && [ "$OUTPUT_FORMAT" != "stdout" ]; then
    command+=" > $OUTPUT_FILE"
fi

# Execute the constructed command
echo "Running Bomber command: $command"
sh -c "$command"