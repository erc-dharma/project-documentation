# Website Pages and Assets

Files under this directory (`project-documentation/website`) are served on the Website, at the corresponding relative location, for instance:

    website/hello.jpg -> https://dharmalekha.info/hello.jpg
    website/images/hello.jpg -> https://dharmalekha.info/images/hello.jpg

To create a Web page, add a markdown file with the page name as file name and
with the extension `*.md`, for instance:

    website/mypage.md -> https://dharmalekha.info/mypage
    website/mypages/mypage.md -> https://dharmalekha.info/mypages/mypage

Sometimes, you want to create a Web page at a given address *and also* host
files under this address. To do so, create a directory with the address name and add a file named `index.md` under this directory. This markdown file will be served at the address of the directory, while other files in this directory will be served normally. For instance, say we have this directory structure:

    website/
       └── mydir/
             ├── foo.png
             └── index.md

The addresses of the files will be:

    website/mydir/index.md -> https://dharmalekha.info/mydir
    website/mydir/foo.png -> https://dharmalekha.info/mydir/foo.png

Likewise, the file `website/index.md` corresponds to the page
`https://dharmalekha.info`.

Before creating a page, check whether there already is a page at this address on the Website. If so, your page will either not be displayed or override the existing one. Both options are undesirable.
