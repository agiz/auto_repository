# auto repository

Semiautomatically create remote github/bitbucket repository.

## What is this?

This script will create remote repository of your current project.

More explicit, it will:
- Create remote repository either on github or bitbucket.
- Initialize your project (`git init)`.s
- Add remote repository (`git remote add origin <provider>`).
- Add all files (`git add .`).
- Commit all changes (`git commit -a -m 'Initial commit.'`).
- Push your project to the remote provider (`git push -u origin master`).

Script only works on vanilla projects without `.git` directory.
If such directory alread exists, script will terminate without
making any modifications.

## What this is not.

This script will not update your project once initial push is completed.

## Instalation

1. Put `auto_repository.sh` somewhere along the executable PATH. `/usr/local/bin` for example.
2. Make script executable `chmod u+x /usr/local/bin/auto_repository.sh`.

## Configuration

Change `USER` variable in `auto_repository.sh` and you are set.
Default provider is bitbucket and default repository visibility
for bitbucket is `PRIVATE`. Default visibility for github is
`PUBLIC`. Change according to your needs.

## Usage

1. Navigate to the project you want to upload: `cd ~/Projects/my_new_project`.
2. Run `auto_repository.sh <bitbucket|github>` in project's directory. Bitbucket
is default provider if no arguments are supplied.
3. You will be prompted to enter a password.
4. There is nothing more to say.

## Credits

[agiz](https://github.com/agiz)

## License

TODO: Write license
