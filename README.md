# bomber-scan

this action is based on bomber by DevOps Kung Fu https://github.com/devops-kung-fu/bomber

this action requires an existing SBOM file in the action workspace. you can use e.g. syft, trivy or any other SBOM generator action before this one to create the SBOM.

these are the options you can set in your workflow:

| Name           | Description                                                                                   | Required | Default       |
|----------------|-----------------------------------------------------------------------------------------------|----------|---------------|
| sbom-file      | the sbom file to scan or syft command to generate and pipe the SBOM into bomber               | true     | sbom.json     |
| data-provider  | snyk or ossindex or ovs                                                                       | false    | ovs           |
| output_format  | Options are stdout, json, html                                                                 | false    | stdout        |
| output-file    | filename for output file. if empty or output not set to html or json, no file will be generated. | false    | bomber_output |
| ignore-file    | name of the file containing CVEs to ignore                                                     | false    |               |
required: false


if you intend to use snyk or ossindex as data sources, name your secrets like this:
SNYK_USERNAME
SNYK_TOKEN
OSSINDEX_USERNAME
OSSINDEX_TOKEN
