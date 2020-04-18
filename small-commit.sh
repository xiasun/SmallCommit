# Author: xiasun@github
# Last update: April 18, 2020
# run `git config --global core.quotepath false` to avoid error for non-ASCII path

sizeLimit=$1
commitMsg=$2

# size limit for single commit is optional, set to 100MB by default
if [ -z $sizeLimit ]
then
    echo "Warning: size limit not set, use 100MB by default"
    sizeLimit=100
fi

# commit message is optional, set to "Small commit" by default
if [ -z $commitMsg ]
then
    echo "Warning: commit message not set, use \"Small commit\" by default"
    commitMsg="Small commit"
fi

echo "Info: size limit: " $sizeLimit "MB"
echo "Info: commit message: " $commitMsg

files=()
filesSize=0
numCommits=0
sizeLimit=$(($sizeLimit * 1000)) # convert to KB in later calculation

git ls-files --others --exclude-standard | while read file; do
    fileSize=`du -k "$file" | cut -f1`

    # one single file too large
    if (($fileSize>=$sizeLimit))
    then
        echo "Error: below file too large for single commit, use LFS instead: " 
        echo "------ " $file
        exit
    fi

    # files size up to 100MB, commit and push them
    if [ $filesSize -gt $sizeLimit ]
    then
        echo "Info: commit no."$numCommits  ${#files[@]} " files, total size " $filesSize

        # add all files
        for f in "${files[@]}"
        do
            git add "$f"
        done
        
        # generate commit messages
        msg="${commitMsg} ${numCommits}"
        let "numCommits++"

        # commit and push
        git commit -m "$msg"
        git push

        # clear commited files and filesSize
        unset files
        filesSize=0

        # add the latest file
        files+=($file)
        filesSize=$(($filesSize + $fileSize))

    else
        files+=($file)
        filesSize=$(($filesSize + $fileSize))
    fi
    # git --git-dir $repoDir/.git add $file
done

