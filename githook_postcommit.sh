#!/bin/sh

COMMIT=$(git rev-parse --short HEAD)
DATE=$(git log -1 --format=%cd --date=format:"%Y%m%d")

git tag -a $DATE-$COMMIT -m "Tagging $DATE-$COMMIT"

echo "                                         "
echo "                   |ZZzzz                "
echo "                   |                     "
echo "                   |                     "
echo "      |ZZzzz      /^\            |ZZzzz  "
echo "      |          |~~~|           |       "
echo "      |        |-     -|        / \      "
echo "     /^\       |[]+    |       |^^^|     "
echo "  |^^^^^^^|    |    +[]|       |   |     "
echo "  |    +[]|/\/\/\/\^/\/\/\/\/|^^^^^^^|   "
echo "  |+[]+   |~~~~~~~~~~~~~~~~~~|    +[]|   "
echo "  |       |  []   /^\   []   |+[]+   |   "
echo "  |   +[]+|  []  || ||  []   |   +[]+|   "
echo "  |[]+    |      || ||       |[]+    |   "
echo "  |_______|------------------|_______|   "
echo "                                         "
echo "                                         "
echo "      You have just committed and tagged "
echo "      your code as $DATE-$COMMIT         "

echo "Removing deprecated un-pushed tags..."
git show-ref --tags | \
  grep -v -F "$(git ls-remote --tags origin | grep -v '\^{}' | cut -f 2)" | \
  grep -v "$(git rev-parse --short HEAD)" | \
  awk -F'/' '{print $3}' | \
  xargs -I{} bash -c "git tag --delete {}"