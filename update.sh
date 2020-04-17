# /bin/zsh

export LANG="en_US.UTF-8"

if [ $1 ]; then
    product=$1
else
    echo "Please provide a product"
    exit 0
fi

if [ $2 ]; then
    tag=$2
else
    echo "Please provide a tag"
    exit 0
fi

if [ "$product" == "sdc" ]; then

    wget https://archives.streamsets.com/datacollector/${tag}/tarball/activation/streamsets-datacollector-core-${tag}.tgz
    export sha256=$(shasum -a 256 streamsets-datacollector-core-${tag}.tgz | awk '{print $1}')
    sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/datacollector\/${tag}\/tarball\/activation\/streamsets-datacollector-core-${tag}.tgz\"/" datacollector-core.rb
    sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" datacollector-core.rb
    rm streamsets-datacollector-core-${tag}.tgz

    wget https://archives.streamsets.com/datacollector/${tag}/tarball/activation/streamsets-datacollector-all-${tag}.tgz
    export sha256=$(shasum -a 256 streamsets-datacollector-all-${tag}.tgz | awk '{print $1}')
    sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/datacollector\/${tag}\/tarball\/activation\/streamsets-datacollector-all-${tag}.tgz\"/" datacollector.rb
    sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" datacollector.rb
    rm streamsets-datacollector-all-${tag}.tgz

    # wget https://archives.streamsets.com/datacollector/${tag}/tarball/SDCe/streamsets-datacollector-edge-${tag}-darwin-amd64.tgz
    # export sha256=$(shasum -a 256 streamsets-datacollector-edge-${tag}-darwin-amd64.tgz | awk '{print $1}')
    # sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/datacollector\/${tag}\/tarball\/SDCe\/streamsets-datacollector-edge-${tag}-darwin-amd64.tgz\"/" datacollector-edge.rb
    # sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" datacollector-edge.rb
    # rm streamsets-datacollector-edge-${tag}-darwin-amd64.tgz

elif [ "$product" == "transformer" ]; then
    wget https://archives.streamsets.com/transformer/${tag}/tarball/streamsets-transformer-all-${tag}.tgz
    export sha256=$(shasum -a 256 /tarball/streamsets-transformer-all-${tag}.tgz | awk '{print $1}')
    sed -i '' "s/url.*/url \"https\:\/\/archives.streamsets.com\/transformer\/${tag}\/tarball\/streamsets-transformer-all-${tag}.tgz\"/" transformer.rb
    sed -i '' "s/sha256.*/sha256 \"${sha256}\"/" transformer.rb
    rm streamsets-transformer-all-${tag}.tgz

else
    echo "Unknown product ${product}"
fi

# git add *
# git commit -m "Update ${product} to version ${tag}"
# git push