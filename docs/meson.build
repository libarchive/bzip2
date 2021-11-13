build_docs = get_option('docs')
docs = find_program('xsltproc', required : build_docs).found()
docs = docs and find_program('perl', required : build_docs).found()
docs = docs and find_program('xmllint', required : build_docs).found()
docs = docs and find_program('grep', required : build_docs).found()
docs = docs and find_program('pdfxmltex', required : build_docs).found()
docs = docs and find_program('pdftops', required : build_docs).found()
prog_sh = find_program('sh', required : build_docs)
if docs and prog_sh.found()
  foreach t : ['pdf', 'ps', 'html']
    custom_target(
      'manual.' + t,
      command : [prog_sh, 'xmlproc.sh', '-' + t, '@OUTPUT@'],
      output : 'manual.' + t,
    )
  endforeach
endif
