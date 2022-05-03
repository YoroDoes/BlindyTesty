cd blindytesty/

flutter build web --base-href='/BlindyTesty/'

git add build/
git commit -m 'web build'

git subtree push --prefix blindytesty/build/web origin gh-pages
