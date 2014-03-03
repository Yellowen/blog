---
layout: post
title: Extending a model of an engine
date: 2014-03-04 16:13
categories: Ruby Rails
tags: Gem
author: lxsameer
description: How to extend a model of an engine
---

Sometimes you may need to add an `instance_method`, include a concern or do any enhancement to your **Rails** application model
which is originally defined in an [engine](http://guides.rubyonrails.org/engines.html). As you may know [Ruby](http://ruby-lang.org)
provides `open classes`(Which I find very interesting). A solution to easily extent already defined class just by redefining (I can't find a better word) them. You can read more about open classes [here](http://rubylearning.com/satishtalim/ruby_open_classes.html).

Theoretically there shouldn't be any problem when you want to re-open a model which is defined in a **Rails** engine. But practically there is **one**.

**Rails** have a mechanism to autoload our code's classes that is very handy. But unfortunately the [autoload mechanism](http://urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/)
will makes problem in this case. **Simon Coffey** wrote a very good [article](http://urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/) about **Rails** autoload mechanism. I highly recommend you to read it.

Back to our problem. If you want to re-open a model, for example `MyEngine::User` you have to create a directory in `myapp/app/models` called
`my_engine` (I assume you already know about **Rails** autoload). Create `user.rb` file and re-open `MyEngine::User` class:

{% highlight ruby linenos %}
class MyEngine::User
  # Do you magic here
end
{% endhighlight %}

As I said earlier this approach should work theoretically, but when Rails tries to autoload `MyEngine::User` model it will find you version of
`MyEngine::User` model first. So user model will define in you file for the first time and **Rails** will not search for other files anymore.
You can see the problem, right ?

To fix this problem all you should do is to require the original model first in your `user.rb` just like this:

{% highlight ruby linenos %}
require MyEngine::Engine.root.join("app", "models", "my_engine", "user")


class MyEngine::User
  # Do you magic here
end
{% endhighlight %}

Now `MyEngine::User` model defines in the right place an you re-open it instead of defining it. Easy, right ?

> Note: There are other solutions like reordering your engines in your config files. But it may cause bigger problems in certain situations.

Have fun.
