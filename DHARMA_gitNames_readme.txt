# DHARMA git user names

The file DHARMA_gitNames.tsv is a mapping between git user names and DHARMA identifiers. By "git
user names" we mean the output of:

	git log --format=%aN

To check your own git name, use:

	git config user.name

This is different from Github user names. Github user names do not appear in
git's commit history, they are only relevant on Github itself. Arguably, it
might be better to use email addresses to identify people, or maybe both emails
and user names, if several persons have the same git name. This is not the case
for now.

Most people do not set proper values for user.name and user.email in git. People
also use several machines or several git setups, so several git user names map
to the same DHARMA member id.

To add a user, you can create a new record in the column git_name and match it with the user's DHARMA id in the column dh_id.

As for users, you should ask them to issue the following with the appropriate values:

git config --global user.name "John Doe"
git config --global user.email "john.doe@gmail.com"

You will still need to fill out the file DHARMA_gitNames.tsv for each new user.
