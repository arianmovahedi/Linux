# Global Gitignore
We can set items to be ignored by git by adding the `~/.gitignire_global` file and add it to the Git global configurations by running the followong commands:
```bash
git config --global core.excludesfile ~/.gitignore_global
```

Any other naming convention can be used but the `.gitignore_global` is very straight forward. We can create and gradually add ignores tot thi file.
```bash
echo .DS_Store >> ~/.gitignore_global
```