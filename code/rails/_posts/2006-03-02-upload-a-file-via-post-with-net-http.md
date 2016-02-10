--- 
layout: post
title: Upload a file via POST with Net::HTTP
---
To upload a file to a website I needed to supply the data with a content type of “multipart/form-data”. The [Net:HTTP](http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html) API does not offer any such functionality, it just accepts raw content data. So I needed to roll my own.

The “multipart/form-data” content type consists of a number of secions separated by `--BOUNDARY\r\n` and terminated by `BOUNDARY--\r\n` where `BOUNDARY` is a string that does not appear in the content of any of the data transmitted to the server.

Each section represents a form field and contains a number of headers, a `\r\n`, the content and finishes with a `\r\n`. Normal form fields look like

    Content-Disposition: form-data; name="mykey"

    mydata

while file fields must include a few more headers.

    Content-Disposition: form-data; name="mykey"; filename="filename"
    Content-Transfer-Encoding: binary
    Content-Type: text/plain

    DATADATADATADATADATADATADATA...

To construct the parameters in ruby I use the following code;

{% highlight ruby %}
def text\_to\_multipart(key,value)
return “Content-Disposition: form-data; name=\\”\#{CGI::escape(key)}\\“\\r\\n” +
“\\r\\n” +
“\#{value}\\r\\n”
end

def file\_to\_multipart(key,filename,mime\_type,content)
return “Content-Disposition: form-data; name=\\”\#{CGI::escape(key)}\\“; filename=\\”\#{filename}\\“\\r\\n” +
“Content-Transfer-Encoding: binary\\r\\n” +
“Content-Type: \#{mime\_type}\\r\\n” +
“\\r\\n” +
“\#{content}\\r\\n”
end
{% endhighlight %}

To put it all together you need to join the parameters with boundary separators between each section. This can be done via

{% highlight ruby %}
boundary = ‘349832898984244898448024464570528145’
query =
params.collect {|p| ‘—’ + boundary + “\\r\\n” + p}.join(’’) + “—” + boundary + “—\\r\\n”
{% endhighlight %}

The last thing that needs to be done is to make sure that you set the HTTP Header `Content-type` to `multipart/form-data; boundary=BOUNDARY`.

A complete example that I extracted from code that uploads a css file to the w3c validator service is as follows.

{% highlight ruby %}
params = \[
file\_to\_multipart(‘file’,‘file.css’,‘text/css’,data),
text\_to\_multipart(‘warning’,‘1’),
text\_to\_multipart(‘profile’,‘css2’),
text\_to\_multipart(‘usermedium’,‘all’) \]

boundary = ‘349832898984244898448024464570528145’
query =
params.collect {|p| ‘—’ + boundary + “\\r\\n” + p}.join(’’) + “—” + boundary + “—\\r\\n”

response = http.start(‘jigsaw.w3.org’).
post2(“/css-validator/validator”,
query,
“Content-type” =&gt; “multipart/form-data; boundary=” + boundary)
{% endhighlight %}

It was a little bit painful to figure out “multipart/form-data” via [Ethereal](http://www.ethereal.com/) but relatively easy to implement. Hope this helps!

**Update 3rd of October, 2006:**

Slight correction supplied by Andrew Willis so that last boundary is <code>‘—’ + boundary + ‘—’</code> rather than just <code>boundary + ‘—’</code>.
