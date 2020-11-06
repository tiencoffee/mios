styl = ""
code = ""
stylIfrm = ""
codeIfrm = ""
tmplIfrm = ""

fetch2 = (path, dataType = \text) ->
	(await fetch path)[dataType]!

Paths = await fetch2 \paths.json \json

tmplIfrm += await fetch2 \iframe.html

a = await fetch2 \styl/both.styl
b = await fetch2 \styl/main.styl
styl += a.replace "{{styl}}" b
b = await fetch2 \styl/ifrm.styl
stylIfrm += a.replace /(?={{styl}})/ b

a = await fetch2 \code/both.ls
code += a
codeIfrm += a
for path in Paths"comp/both"
	a = await fetch2 path
	code += a
	codeIfrm += a
for path in Paths"comp/main"
	code += await fetch2 path
code += await fetch2 \code/main.ls
codeIfrm += await fetch2 \code/ifrm.ls

window.tmplIfrm = tmplIfrm
window.stylIfrm = stylIfrm
window.codeIfrm = codeIfrm
window.Paths = Paths

styl = stylus.render styl, {+compress}
stylEl.textContent = styl

livescript.run code
