// Client code

import java.util.ArrayList;

public class Lecture02 {

  static void main() {

    // Procedural programming style

    System.out.println("Hello World");

    // classical
    // standard for loop
    for (int i = 0; i < 10; i++) {
      System.out.println((i + 1) + ". Java");
    }

    String name = "Berk";
    int age = 12;
    double height = 191.3;
    // boolean isMarried = false;
    // char gender = 'M';

    System.out.println("Student name: " + name + ", age: " + age);
    // System.out.println("Height: " + height);
    System.out.printf("Height: %.4f\n", height);
    System.out.println("Java");

    if (age > 10) {
      System.out.println("A");
      System.out.println("A");
    }
    else
      System.out.printf("B");

    // Scanner input = new Scanner(System.in);
    // System.out.println("Enter a number:");
    // int number = input.nextInt();
    // System.out.println("You entered: " + number);

    printInfo(name, age);


    // Part.2 OOP Version

    System.out.println();
    Student myStudent = new Student("Berk", -1);
    // System.out.println(myStudent.name);
    // System.out.println(myStudent.age);
    System.out.println(myStudent);
    //System.out.println(myStudent.height);
    myStudent.height = 191.3;
    System.out.println(myStudent.height);

    // myStudent.age= -1;
    myStudent.setAge(-3);
    System.out.println(myStudent);
    System.out.println(myStudent.getAge());


    System.out.println();

    ArrayList<Student> students = new ArrayList<>();
    students.add(new Student("A", 1));
    students.add(new Student("B", 2));
    students.add(new Student("C", 3));

    // for-each loop
    // enhanced for loop
    for (Student curStudent : students) {
      System.out.println(curStudent);
    }

  } // end of main

  public static void printInfo(String n, int a) {
    System.out.println("Student name: " + n + ", age: " + a);
  }


}
