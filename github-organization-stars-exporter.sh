#!/bin/bash
set -euo pipefail

read -rp "Enter GitHub organization name: " org_name

if [ -z "$org_name" ]; then
    echo "Error: organization name cannot be empty"
    exit 1
fi

filename="${org_name}-$(date +%Y%m%d_%H%M%S).csv"
if [ -f "$filename" ]; then
    echo "Error: file '$filename' already exists"
    exit 1
fi

echo "Fetching data for organization '$org_name'..."

# Initialize variable to store CSV data
csv_data="Repository,Stars"

# Get organization repositories via GitHub API
# Use pagination to get all repositories
page=1
per_page=100
repo_count=0
total_stars=0

while true; do
    response=$(curl -s "https://api.github.com/orgs/${org_name}/repos?per_page=${per_page}&page=${page}&sort=stars&direction=desc")

    if echo "$response" | grep -q '"message"'; then
        error_message=$(echo "$response" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
        echo "GitHub API error: $error_message"
        exit 1
    fi

    repos_count=$(echo "$response" | grep -o '"name"' | wc -l)
    if [ "$repos_count" -eq 0 ]; then
        break
    fi

    repos_data=$(echo "$response" | jq -r '.[] | "\(.name),\(.stargazers_count)"')
    csv_data="${csv_data}"$'\n'"${repos_data}"

    # Count total stars
    page_stars=$(echo "$response" | jq '[.[].stargazers_count] | add')
    total_stars=$((total_stars + page_stars))
    repo_count=$((repo_count + repos_count))

    if [ "$repos_count" -lt "$per_page" ]; then
        break
    fi

    page=$((page + 1))
done

if [ "$repo_count" -eq 0 ]; then
    echo "Warning: no repositories found for organization '$org_name'"
fi

# Sort by star count (descending) and write to file
{
    echo "$csv_data" | head -n 1
    echo "$csv_data" | tail -n +2 | sort -t',' -k2 -rn
} > "$filename"

echo "Done! Data saved to file: $filename"
echo "Total repositories: $repo_count"
echo "Total stars: $total_stars"
