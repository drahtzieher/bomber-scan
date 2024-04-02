# bomber-scan

this action is based on bomber by DevOps Kung Fu https://github.com/devops-kung-fu/bomber

this action requires an existing SBOM file in the action workspace. you can use e.g. syft, trivy or any other SBOM generator action before this one to create the SBOM.

these are the options you can set in your workflow:
name: 'bomber-action'
description: 'Action using DevOps Kung Fu Bomber'
author: Drahtzieher
inputs:
  sbom-file:
    description: 'the sbom file to scan or syft command to generate and pipe the SBOM iinto bomber'
    required: true
    default: sbom.json
  data-provider:
    description: 'snyk or ossindex or ovs'
    required: false
    default: "ovs"
  output_format:
    description: 'Options are stdout, json,html'
    required: false
    default: "stdout"
  output-file:
    description: 'filename for output file. if empty or output not set to html or json, no file will be generated.'
    required: false
    default: bomber_output
  ignore-file:
    description: name of the file containing CVEs to ignore
    required: false


if you intend to use snyk or ossindex as data sources, name your secrets like this:
SNYK_USERNAME
SNYK_TOKEN
OSSINDEX_USERNAME
OSSINDEX_TOKEN
