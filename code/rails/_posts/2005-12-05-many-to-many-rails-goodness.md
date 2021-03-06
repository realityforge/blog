------------------------------------------------------------------------

layout: post
title: Many-to-many rails goodness with the through directive
—-
The has\_many :through option will rock your socks off! (Or at least make things a little easier) Read on to understand why!

Rails has the ability to declare many-to-many relationships between ActiveRecord objects using the [has\_and\_belongs\_to\_many](http://api.rubyonrails.com/classes/ActiveRecord/Associations/ClassMethods.html#M000467) macro. HABTM relationships as they are affectionately known, require a third join table that contains the keys of the two domain objects.

Consider the example where a Student can be enrolled in 1 or more Subjects and each Subject can have 1 or more Students. This would be modelled by the following domain classes.

{% highlight ruby %}
class Student &lt; ActiveRecord::Base
has\_and\_belongs\_to\_many :subjects
…
end

class Subject &lt; ActiveRecord::Base
has\_and\_belongs\_to\_many :students
…
end
{% endhighlight %}

With the sql DDL looking something like;


    CREATE TABLE students (
      id INT NOT NULL AUTO_INCREMENT,
      name VARCHAR(100) NOT NULL,
      ...
      PRIMARY KEY (id) 
    ) ENGINE = InnoDB;

    CREATE TABLE subjects (
      id INT NOT NULL AUTO_INCREMENT,
      name VARCHAR(100) NOT NULL,
      ...
      PRIMARY KEY (id) 
    ) ENGINE = InnoDB;

    CREATE TABLE students_subjects (
      student_id INT NOT NULL,
      subjects_id INT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES students(id),
      FOREIGN KEY (subject_id) REFERENCES subjects(id)
    ) ENGINE = InnoDB;

At some point you may want to add in some information
about the HABTM relationship such as the year that the
student enrolled in the subject. This can be done using
<code>push\_with\_attributes</code> and adding an extra
‘year’ column to the SQL DDL.

{% highlight ruby %}
class Subject &lt; ActiveRecord::Base
has\_and\_belongs\_to\_many :students
…
def enrol(student)
students.push\_with\_attributes(student, :year =&gt; Time.now.year)
end
end
{% endhighlight %}

Join tables with attributes tend to become ugly fast and it
is rare that a few days don’t go by on the rails mailing list without
someone asking for features that imply they are using join tables as
a crutch for a missing domain object. Enrolment would be a good choice
for the example above.

However if we introduce an Enrolment object, the naive approach of
accessing the students of the subject (or vice versa) is extremely
inefficient as you will first hit the enrolments table before loading
from the students table (or conversly the subjects table). A more
efficient way using hand crafted SQL would be the following

{% highlight ruby %}
class Subject &lt; ActiveRecord::Base
has\_many :enrolments
…
def students
find\_by\_sql(
“SELECT students.\* ” +
“FROM subjects, enrolments, students ” +
“WHERE enrolments.student\_id = students.id AND + ”
" enrolments.subject\_id = \#{id}"
)
end
end
{% endhighlight %}

This pattern is likely to be duplicated across many domain objects.
Luckily David Heinemeier Hansson [mentioned](http://article.gmane.org/gmane.comp.lang.ruby.rails/32742/)
that a <code>:through</code> option will be supported on the the <code>has\_many</code> macro that allows you to replace the above code with;

{% highlight ruby %}
class Subject &lt; ActiveRecord::Base
has\_many :enrolments
has\_many :students, :through =&gt; :enrolments
…
end
{% endhighlight %}

Rails just keeps getting better and better!
