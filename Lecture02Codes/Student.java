// Class code

public class Student {

  // data fields
  // attributes
  // properties

  public String name;
  private int age;
  public double height;

  public Student(String name, int age) {
    this.name = name;
    //this.age = age;
    setAge(age);
  }

  // setter methods
  public void setAge(int age) {
    if (age > 0)
      this.age = age;
  }

  public int getAge() {
    return age;
  }

  @Override
  public String toString() {
    return name + ", age=" + age;
  }
}
