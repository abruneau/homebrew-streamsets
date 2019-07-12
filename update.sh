# /bin/zsh

export LANG="en_US.UTF-8"

if [ $1 ]; then
    tag=$1
else
    echo "Please provide a tag"
    exit 0
fi

wget https://archives.streamsets.com/datacollector/${tag}/tarball/streamsets-datacollector-core-${tag}.tgz
export sha256=$(shasum -a 256 streamsets-datacollector-core-${tag}.tgz | awk '{print $1}')
sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/datacollector\/${tag}\/tarball\/streamsets-datacollector-core-${tag}.tgz\"/" datacollector-core.rb
sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" datacollector-core.rb
rm streamsets-datacollector-core-${tag}.tgz

wget https://archives.streamsets.com/datacollector/${tag}/tarball/streamsets-datacollector-all-${tag}.tgz
export sha256=$(shasum -a 256 streamsets-datacollector-all-${tag}.tgz | awk '{print $1}')
sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/datacollector\/${tag}\/tarball\/streamsets-datacollector-core-${tag}.tgz\"/" datacollector.rb
sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" datacollector.rb
rm streamsets-datacollector-all-${tag}.tgz

git add *
git commit -m "Update to version ${tag}"
git push