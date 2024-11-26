
# Check if a commit message is provided
if [ -z "$1" ]; then
    echo "Error: Commit message is required."
    echo "Usage: ./git-auto.sh \"Your commit message\""
    exit 1
fi

# Run Git commands
echo "Adding changes..."
git add .

echo "Committing changes..."
git commit -m "$1"

echo "Pushing changes..."
git push

echo "Done!"
