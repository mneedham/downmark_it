require '../downmark_it'

describe "downmark_it" do
  describe "pre tag" do 
    it "should be converted into highlight syntax" do
      input = <<-EOS
        <pre lang="ruby">
        class Foo
          def bar
            "hello"
          end
        end
        </pre>
      EOS
      
      DownmarkIt.to_markdown(input).should == <<-EOS
        {% highlight ruby %}
        class Foo
          def bar
            "hello"
          end
        end
        {% endhighlight %}
      EOS
    end

    it "should show line numbers if required" do
      input = <<-EOS
        <pre lang="ruby" line="1">
        class Foo
          def bar
            "hello"
          end
        end
        </pre>
      EOS
      
      DownmarkIt.to_markdown(input).should == <<-EOS
        {% highlight ruby linenos linenostart 1 %}
        class Foo
          def bar
            "hello"
          end
        end
        {% endhighlight %}
      EOS
    end

    it "should replace more than one of these tags" do
      input = <<-EOS
      So we have some code here:
        <pre lang="ruby" line="1">
        class Foo
          def bar
            "hello"
          end
        end
        </pre>
      And then some more here:
        <pre lang="ruby" line="1">
        class Card
          def get_well_soon
            "do it"
          end
        end
        </pre>
      EOS
      
      DownmarkIt.to_markdown(input).should == <<-EOS
      So we have some code here:
        {% highlight ruby linenos linenostart 1 %}
        class Foo
          def bar
            "hello"
          end
        end
        {% endhighlight %}
      And then some more here:
        {% highlight ruby linenos linenostart 1 %}
        class Card
          def get_well_soon
            "do it"
          end
        end
        {% endhighlight %}
      EOS
    end
  end
end
