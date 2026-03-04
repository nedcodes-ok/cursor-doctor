#!/bin/bash
# generate-badge.sh - Create a shields.io endpoint badge JSON for Cursor Rules Health

set -e

# Run cursor-doctor check --json and capture output
JSON_OUTPUT=$(npx cursor-doctor check --json 2>/dev/null || echo '{}')

# Extract grade and percentage
GRADE=$(echo "$JSON_OUTPUT" | grep -oP '"grade":\s*"\K[A-F]' || echo "F")
PERCENTAGE=$(echo "$JSON_OUTPUT" | grep -oP '"percentage":\s*\K[0-9]+' || echo "0")

# Color mapping
case "$GRADE" in
  A) COLOR="brightgreen" ;;
  B) COLOR="green" ;;
  C) COLOR="yellow" ;;
  D) COLOR="orange" ;;
  F) COLOR="red" ;;
  *) COLOR="lightgrey" ;;
esac

# Generate shields.io endpoint badge JSON
cat > .cursor-doctor-badge.json <<EOF
{
  "schemaVersion": 1,
  "label": "Cursor Rules",
  "message": "$GRADE ($PERCENTAGE%)",
  "color": "$COLOR"
}
EOF

echo "✓ Badge generated: $GRADE ($PERCENTAGE%) → .cursor-doctor-badge.json"
