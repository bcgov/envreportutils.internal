# envreportutils.internal

![img](https://img.shields.io/badge/Lifecycle-Stable-97ca00)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


## Overview

An [R](http://r-project.org) package containing templates & internal utility functions for [Environmental Reporting BC](http://www2.gov.bc.ca/gov/content?id=FF80E0B985F245CEA62808414D78C41B). 

You can visit the [Wiki](https://github.com/bcgov-c/envreportutils.internal/wiki/EnvReportBC-Team-Wiki) to find documentation on tools and related program work flows.

## Usage

Install with:

```r
## install.packages("devtools") # if not already installed
devtools::install_github("bcgov-c/envreportutils.internal")
```

## Project Status

Relatively stable, but under constant development. This package contains templates for creating products with B.C. Government and Environmental Reporting BC specific branding, and thus is maintained in a private repository.

*Note:* We recently renamed the package from **envreportbc** to **envreportutils.internal**. To install the new package, run: 

```r
remove.packages("envreportbc")
remotes::install_github("bcgov-c/envreportutils.internal")
```

If you contribute to the package, you will want to rename your remote: Rename the folder from `envreportbc` to `envreportutils.internal`, `cd` into the directory, and type: `git remote set-url origin https://github.com/bcgov-c/envreportutils.internal.git`

(Or simply delete the `envreportbc` directory, and type `git clone https://github.com/bcgov-c/envreportutils.internal.git`)

## Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/bcgov-c/envreportutils.internal/issues/).

## How to Contribute

If you would like to contribute, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

    Copyright 2017 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at 

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    

This repository is maintained by [Environmental Reporting BC](http://www2.gov.bc.ca/gov/content?id=FF80E0B985F245CEA62808414D78C41B). Click [here](https://github.com/bcgov/EnvReportBC) for a complete list of our public repositories on GitHub.
