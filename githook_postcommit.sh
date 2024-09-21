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
