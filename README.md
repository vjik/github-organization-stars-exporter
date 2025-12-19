# GitHub Organization Stars Exporter

[![Release](https://img.shields.io/github/v/release/vjik/github-organization-stars-exporter)](https://github.com/vjik/github-organization-stars-exporter/releases)
[![ShellCheck](https://github.com/vjik/github-organization-stars-exporter/actions/workflows/shellcheck.yml/badge.svg?branch=master)](https://github.com/vjik/github-organization-stars-exporter/actions/workflows/shellcheck.yml?query=branch%3Amaster)
[![License](https://img.shields.io/github/license/vjik/github-organization-stars-exporter)](./LICENSE.md)

A simple bash script that exports GitHub organization repositories and their star counts to a CSV file:

```
$ ./github-organization-stars-exporter.sh
Enter GitHub organization name: yiisoft
Fetching data for organization 'yiisoft'...
Done! Data saved to file: yiisoft-20251219_134817.csv
Total repositories: 209
Total stars: 34327
```

## Features

- Fetches all repositories from a GitHub organization
- Exports repository names and star counts to CSV format
- Automatic pagination for organizations with many repositories
- Sorts results by star count (descending)
- Displays total repository count and total stars
- Prevents overwriting existing files with timestamp-based naming

## Requirements

- [`bash`](https://www.gnu.org/software/bash/)
- [`curl`](https://curl.se/)
- [`jq`](https://jqlang.org/)

## Usage

1. Make the script executable:
```bash
chmod +x github-organization-stars-exporter.sh
```

2. Run the script:
```bash
./github-organization-stars-exporter.sh
```

3. Enter the GitHub organization name when prompted

4. The script will create a CSV file named `ORGANIZATION-TIMESTAMP.csv` in the current directory

## Output Format

The generated CSV file contains two columns:
- `Repository` - Repository name
- `Stars` - Number of stars

Example:
```csv
Repository,Stars
yii2,14317
yii,4838
yii2-app-advanced,1671
```

## License

The GitHub Organization Stars Exporter is free software. It is released under the terms of the BSD License.
Please see [`LICENSE`](./LICENSE.md) for more information.
