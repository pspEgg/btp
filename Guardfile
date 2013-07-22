# A sample Guardfile
# More info at https://github.com/guard/guard#readme
jekyll_plus_args = {
  :serve => true, 
  :extensions => ['md','markdown','html','rb','yml','scss']
}
guard :jekyllplus, jekyll_plus_args do
  watch /.*/
  ignore /^_site/
end
