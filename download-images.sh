#!/bin/bash

# Script to download images from Figma MCP localhost server
# and update HTML to use local paths

# Check if site directory argument is provided
if [ $# -ne 1 ]; then
    echo "❌ Error: Please specify the site directory"
    echo "Usage: $0 <site_directory>"
    echo "Example: $0 site_area-landing"
    echo ""
    echo "Available site directories:"
    ls -d site_* 2>/dev/null || echo "  (no site directories found)"
    exit 1
fi

SITE_DIR="$1"
ASSETS_DIR="${SITE_DIR}/assets"
HTML_FILE="${SITE_DIR}/index.html"
HTML_BACKUP="${SITE_DIR}/index.html.backup"

echo "=========================================="
echo "  Figma Image Asset Downloader"
echo "=========================================="
echo "📁 Target site: $SITE_DIR"
echo ""

# Check if site directory exists
if [ ! -d "$SITE_DIR" ]; then
    echo "❌ Error: Site directory not found: $SITE_DIR"
    echo ""
    echo "Available site directories:"
    ls -d site_* 2>/dev/null || echo "  (no site directories found)"
    exit 1
fi

# Create assets directory
echo "📁 Creating assets directory..."
mkdir -p "$ASSETS_DIR"
echo "✅ Created: $ASSETS_DIR"
echo ""

# Backup HTML file
echo "💾 Backing up HTML file..."
cp "$HTML_FILE" "$HTML_BACKUP"
echo "✅ Backup created: $HTML_BACKUP"
echo ""

# Extract image URLs from HTML
echo "🔍 Extracting image URLs from HTML..."
image_urls=$(grep -oP 'http://localhost:3845/assets/[a-f0-9]+\.png' "$HTML_FILE" | sort -u)

if [ -z "$image_urls" ]; then
    echo "⚠️  No images found in HTML"
    exit 0
fi

image_count=$(echo "$image_urls" | wc -l)
echo "📸 Found $image_count unique images"
echo ""

# Download each image
echo "⬇️  Downloading images..."
counter=0
failed=0

while IFS= read -r url; do
    counter=$((counter + 1))
    filename=$(basename "$url")
    output_path="$ASSETS_DIR/$filename"
    
    echo "[$counter/$image_count] Downloading: $filename"
    
    if curl -s -f -o "$output_path" "$url"; then
        echo "    ✅ Success: $output_path"
    else
        echo "    ❌ Failed: $url"
        failed=$((failed + 1))
    fi
done <<< "$image_urls"

echo ""
if [ $failed -eq 0 ]; then
    echo "✅ All $image_count images downloaded successfully!"
else
    echo "⚠️  Downloaded $((image_count - failed))/$image_count images ($failed failed)"
    echo "   Make sure Figma MCP server is running on localhost:3845"
fi
echo ""

# Update HTML to use local paths
echo "🔧 Updating HTML to use local image paths..."
sed -i 's|http://localhost:3845/assets/|./assets/|g' "$HTML_FILE"
echo "✅ HTML updated"
echo ""

# Verify changes
updated_count=$(grep -c './assets/' "$HTML_FILE")
echo "📊 Statistics:"
echo "   - Total images in HTML: $updated_count"
echo "   - Images downloaded: $((image_count - failed))"
echo "   - Backup saved: $HTML_BACKUP"
echo ""

echo "=========================================="
echo "✅ Image asset migration complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Verify images in your browser: open $HTML_FILE"
echo "2. If everything looks good:"
echo "   git add $SITE_DIR/assets $HTML_FILE"
echo "   git commit -m 'Add local image assets and update paths'"
echo "   git push"
echo ""
echo "If something went wrong, restore backup:"
echo "   cp $HTML_BACKUP $HTML_FILE"
