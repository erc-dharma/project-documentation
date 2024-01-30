# DHARMA git user names

The file DHARMA_gitNames.csv maps git user names to DHARMA members ids. By "git
user names" we mean the output of:

	git log --format=%aN

This is different from Github user names. Github user names do not appear in
git's commit history, they are only relevant on Github itself. Arguably, it
might be better to use email addresses to identify people, or maybe both emails
and user names, if several persons have the same git name. This is not the case
for now.

Most people do not set proper values for user.name and user.email in git. People
also use several machines or several git setups, so several git user names map
to the same DHARMA member id.
