if [ $# -eq 0 ];
then
  echo "Usage: ./build_and_deploy.sh \"quoted commit message\""
  exit
fi

if [ ! -d "out" ]; then
  echo "Nothing to deploy. Run ./build.sh before ./deploy.sh"
  exit
fi

git checkout gh-pages
git mv .gitignore.gh.pages .gitignore
git add .gitignore out
git commit -m $1
git push origin gh-pages
git checkout master
