if [ ! -d "out" ]; then
  echo "Nothing to deploy. Run ./build.sh before ./deploy.sh"
  exit
fi

git checkout gh-pages
git mv .gitignore.gh.pages .gitignore
git add .gitignore out
git commit -m "Deploy"
git push origin gh-pages
git checkout master
