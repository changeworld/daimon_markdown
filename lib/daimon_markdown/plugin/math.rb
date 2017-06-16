module DaimonMarkdown
  class Plugin
    class Math < Base
      Plugin.register("math", self)

      def self.script_tag
        tag = <<~TAG
        <script type="text/x-mathjax-config">
          MathJax.Hub.Config({
            tex2jax: {inlineMath: [['$','$']]},
            asciimath2jax: {delimiters: [['`', '`']]},
            TeX: {extensions: ["mhchem.js"]}
          });
        </script>
        <script type="text/javascript"
                async
                src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.6-latest/MathJax.js?config=TeX-MML-AM_CHTML">
        </script>
        TAG
        if tag.respond_to?(:html_safe)
          tag.html_safe
        else
          tag
        end
      end

      def call(expression)
        if expression.start_with?("$$")
          node.parent.replace(%Q(<div class="math">#{expression}</div>))
        else
          result[:plugins] << expression
        end
      end
    end
  end
end
