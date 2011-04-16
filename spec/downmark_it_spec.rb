require '../downmark_it'

describe "downmark_it" do
  describe "img tag" do
    it "should leave img tags alone if they are within a div tag" do
      input = <<-EOS
      <div align="center" >
        <div style="float:left; padding-left:30px;">
          <img src="http://www.markhneedham.com/blog/wp-content/uploads/2011/03/twu-topics-todo.jpg" border="0" height="383" alt="Twu topics todo" width="271" />
        </div>
        <div >
          <img src="http://www.markhneedham.com/blog/wp-content/uploads/2011/03/twu-topics-done.jpg" border="0" height="383" alt="Twu topics done" width="271" />
        </div>
      </div>
      EOS

      DownmarkIt.to_markdown(input).should == <<-EOS
      <div align="center">
        <div style="float:left; padding-left:30px;">
          <img src="http://www.markhneedham.com/blog/wp-content/uploads/2011/03/twu-topics-todo.jpg" border="0" height="383" alt="Twu topics todo" width="271" />
        </div>
        <div>
          <img src="http://www.markhneedham.com/blog/wp-content/uploads/2011/03/twu-topics-done.jpg" border="0" height="383" alt="Twu topics done" width="271" />
        </div>
      </div>
      EOS

    end
  end

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

    it "should set the lang to be text if one isn't defined" do
      input = <<-EOS
        <pre>
        class Foo
          def bar
            "hello"
          end
        end
        </pre>
      EOS
      
      DownmarkIt.to_markdown(input).should == <<-EOS
        {% highlight text %}
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
