require! {
	"fs-extra": fs
	pug
}
process.chdir __dirname

Paths = {}
paths = <[
	comp/both
	comp/main
]>
for path in paths
	Paths[path] = fs.readdirSync path .map ~> "#path/#it"
fs.outputJsonSync \paths.json Paths, spaces: \\t

html = pug.renderFile \tmpl/main.pug
fs.outputFileSync \index.html html
html = pug.renderFile \tmpl/ifrm.pug
fs.outputFileSync \iframe.html html
