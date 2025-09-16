# Java Streams Interview Questions

## Table of Contents
1. [**Q1: What are Java Streams? Why were they introduced?**](#q1-what-are-java-streams-why-were-they-introduced)
2. [**Q2: Explain the difference between intermediate and terminal operations.**](#q2-explain-the-difference-between-intermediate-and-terminal-operations)
3. [**Q3: Create a stream from different sources.**](#q3-create-a-stream-from-different-sources)
4. [**Q4: Demonstrate filter, map, and collect operations.**](#q4-demonstrate-filter-map-and-collect-operations)
5. [**Q5: Working with flatMap - explain with examples.**](#q5-working-with-flatmap---explain-with-examples)
6. [**Q6: Sorting with sorted() method.**](#q6-sorting-with-sorted-method)
7. [**Q7: Different ways to collect stream results.**](#q7-different-ways-to-collect-stream-results)
8. [**Q8: Explain reduce() operation with examples.**](#q8-explain-reduce-operation-with-examples)
9. [**Q9: Finding elements with findFirst(), findAny(), anyMatch(), etc.**](#q9-finding-elements-with-findfirst-findany-anymatch-etc)
10. [**Q10: Working with parallel streams - when and how to use.**](#q10-working-with-parallel-streams---when-and-how-to-use)
11. [**Q11: Custom Collectors - create your own collector.**](#q11-custom-collectors---create-your-own-collector)
12. [**Q12: Working with Optional and Stream integration.**](#q12-working-with-optional-and-stream-integration)
13. [**Q13: Multi-level grouping and advanced collectors.**](#q13-multi-level-grouping-and-advanced-collectors)
14. [**Q14: Stream operations with databases/external APIs.**](#q14-stream-operations-with-databasesexternal-apis)
15. [**Q15: Performance optimization and best practices.**](#q15-performance-optimization-and-best-practices)
16. [**Q16: What will be the output of this code?**](#q16-what-will-be-the-output-of-this-code)
17. [**Q17: Fix the bugs in these stream operations.**](#q17-fix-the-bugs-in-these-stream-operations)
18. [**Q18: Memory and performance gotchas.**](#q18-memory-and-performance-gotchas)
19. [**Q19: Process large CSV data using streams.**](#q19-process-large-csv-data-using-streams)
20. [**Q20: API response transformation using streams.**](#q20-api-response-transformation-using-streams)
21. [**Q21: Complex data validation using streams.**](#q21-complex-data-validation-using-streams)
22. [**Q22: Common mistakes to avoid with streams.**](#q22-common-mistakes-to-avoid-with-streams)
23. [**Q23: Performance optimization techniques.**](#q23-performance-optimization-techniques)
24. [**Q24: When NOT to use streams.**](#q24-when-not-to-use-streams)
25. [**Q25: Create a custom stream implementation.**](#q25-create-a-custom-stream-implementation)
26. [**Q26: Implement a streaming data processor with backpressure handling.**](#q26-implement-a-streaming-data-processor-with-backpressure-handling)

---

## 🌊 **Stream Basics - Easy Level**

### **Q1: What are Java Streams? Why were they introduced?**

```java
// Traditional approach (before Java 8)
List<String> names = Arrays.asList("John", "Jane", "Jack", "Jill");
List<String> filteredNames = new ArrayList<>();
for (String name : names) {
    if (name.startsWith("J")) {
        filteredNames.add(name.toUpperCase());
    }
}

// Stream approach (Java 8+)
List<String> filteredNames = names.stream()
    .filter(name -> name.startsWith("J"))
    .map(String::toUpperCase)
    .collect(Collectors.toList());

/*
Benefits of Streams:
1. Declarative programming (what, not how)
2. Functional approach with lambda expressions
3. Parallel processing support
4. Better readability and maintainability
5. Lazy evaluation for performance
*/
```

### **Q2: Explain the difference between intermediate and terminal operations.**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// Intermediate Operations (lazy, return Stream)
Stream<Integer> evenNumbers = numbers.stream()
    .filter(n -> n % 2 == 0)     // Intermediate
    .map(n -> n * 2);            // Intermediate

// Terminal Operations (eager, trigger execution)
List<Integer> result = evenNumbers.collect(Collectors.toList()); // Terminal
long count = numbers.stream().count();                           // Terminal
numbers.stream().forEach(System.out::println);                  // Terminal

/*
Key Differences:
- Intermediate: filter, map, sorted, distinct, limit, skip
- Terminal: collect, forEach, reduce, count, findFirst, anyMatch
- Streams are lazy - intermediate operations don't execute until terminal operation
*/
```

### **Q3: Create a stream from different sources.**

```java
// From Collection
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> streamFromList = list.stream();

// From Array
String[] array = {"x", "y", "z"};
Stream<String> streamFromArray = Arrays.stream(array);

// Using Stream.of()
Stream<String> streamOf = Stream.of("hello", "world");

// Using Stream.builder()
Stream<String> streamBuilder = Stream.<String>builder()
    .add("one")
    .add("two")
    .build();

// Infinite Streams
Stream<Integer> infiniteNumbers = Stream.iterate(0, n -> n + 1);
Stream<Double> randomNumbers = Stream.generate(Math::random);

// From range
IntStream range = IntStream.range(1, 10);        // 1 to 9
IntStream rangeClosed = IntStream.rangeClosed(1, 10); // 1 to 10

// From file (Java 8 NIO)
try (Stream<String> lines = Files.lines(Paths.get("file.txt"))) {
    lines.forEach(System.out::println);
}
```

---

## 🔄 **Intermediate Operations - Easy to Medium**

### **Q4: Demonstrate filter, map, and collect operations.**

```java
class Employee {
    private String name;
    private String department;
    private int salary;
    private int age;
    
    // Constructor, getters, setters
    public Employee(String name, String department, int salary, int age) {
        this.name = name;
        this.department = department;
        this.salary = salary;
        this.age = age;
    }
    
    // getters...
    public String getName() { return name; }
    public String getDepartment() { return department; }
    public int getSalary() { return salary; }
    public int getAge() { return age; }
}

List<Employee> employees = Arrays.asList(
    new Employee("John", "IT", 75000, 30),
    new Employee("Jane", "HR", 65000, 28),
    new Employee("Jack", "IT", 80000, 32),
    new Employee("Jill", "Finance", 70000, 29)
);

// Filter employees from IT department with salary > 70000
List<Employee> itEmployees = employees.stream()
    .filter(emp -> "IT".equals(emp.getDepartment()))
    .filter(emp -> emp.getSalary() > 70000)
    .collect(Collectors.toList());

// Map to employee names only
List<String> employeeNames = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toList());

// Map to uppercase names
List<String> upperCaseNames = employees.stream()
    .map(Employee::getName)
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

### **Q5: Working with flatMap - explain with examples.**

```java
// Flattening nested collections
List<List<String>> nestedList = Arrays.asList(
    Arrays.asList("a", "b"),
    Arrays.asList("c", "d"),
    Arrays.asList("e", "f")
);

// Without flatMap - won't work as expected
// Stream<List<String>> = nestedList.stream().map(list -> list);

// With flatMap - flattens the structure
List<String> flattenedList = nestedList.stream()
    .flatMap(List::stream)
    .collect(Collectors.toList());
// Result: ["a", "b", "c", "d", "e", "f"]

// Real-world example: Get all skills from employees
class Employee {
    private String name;
    private List<String> skills;
    
    public Employee(String name, List<String> skills) {
        this.name = name;
        this.skills = skills;
    }
    
    public List<String> getSkills() { return skills; }
    public String getName() { return name; }
}

List<Employee> employees = Arrays.asList(
    new Employee("John", Arrays.asList("Java", "Python", "SQL")),
    new Employee("Jane", Arrays.asList("JavaScript", "React", "CSS")),
    new Employee("Jack", Arrays.asList("Java", "Spring", "MongoDB"))
);

// Get all unique skills
Set<String> allSkills = employees.stream()
    .flatMap(emp -> emp.getSkills().stream())
    .collect(Collectors.toSet());
// Result: [Java, Python, SQL, JavaScript, React, CSS, Spring, MongoDB]

// Get employees who know Java
List<String> javaExperts = employees.stream()
    .filter(emp -> emp.getSkills().contains("Java"))
    .map(Employee::getName)
    .collect(Collectors.toList());
```

### **Q6: Sorting with sorted() method.**

```java
List<String> names = Arrays.asList("John", "Alice", "Bob", "Charlie");

// Natural sorting
List<String> sortedNames = names.stream()
    .sorted()
    .collect(Collectors.toList());

// Reverse sorting
List<String> reverseSorted = names.stream()
    .sorted(Comparator.reverseOrder())
    .collect(Collectors.toList());

// Custom sorting - by length
List<String> sortedByLength = names.stream()
    .sorted(Comparator.comparing(String::length))
    .collect(Collectors.toList());

// Employee sorting examples
List<Employee> employees = getEmployees(); // assume we have this method

// Sort by salary (ascending)
List<Employee> sortedBySalary = employees.stream()
    .sorted(Comparator.comparing(Employee::getSalary))
    .collect(Collectors.toList());

// Sort by salary (descending)
List<Employee> sortedBySalaryDesc = employees.stream()
    .sorted(Comparator.comparing(Employee::getSalary).reversed())
    .collect(Collectors.toList());

// Multi-level sorting: first by department, then by salary
List<Employee> multiLevelSort = employees.stream()
    .sorted(Comparator.comparing(Employee::getDepartment)
            .thenComparing(Employee::getSalary))
    .collect(Collectors.toList());

// Custom comparator with nulls handling
List<Employee> sortedWithNulls = employees.stream()
    .sorted(Comparator.comparing(Employee::getName, 
            Comparator.nullsLast(String::compareTo)))
    .collect(Collectors.toList());
```

---

## 🎯 **Terminal Operations - Medium Level**

### **Q7: Different ways to collect stream results.**

```java
List<Employee> employees = getEmployees();

// Basic collections
List<String> namesList = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toList());

Set<String> namesSet = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toSet());

// Collect to specific implementation
ArrayList<String> arrayList = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toCollection(ArrayList::new));

TreeSet<String> treeSet = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toCollection(TreeSet::new));

// Collect to Map
Map<String, Integer> nameToAge = employees.stream()
    .collect(Collectors.toMap(
        Employee::getName,
        Employee::getAge
    ));

// Collect to Map with duplicate key handling
Map<String, Employee> nameToEmployee = employees.stream()
    .collect(Collectors.toMap(
        Employee::getName,
        Function.identity(),
        (existing, replacement) -> existing // Keep first occurrence
    ));

// Group by department
Map<String, List<Employee>> byDepartment = employees.stream()
    .collect(Collectors.groupingBy(Employee::getDepartment));

// Group by department and count
Map<String, Long> departmentCount = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.counting()
    ));

// Partition by condition (boolean grouping)
Map<Boolean, List<Employee>> partitionBySalary = employees.stream()
    .collect(Collectors.partitioningBy(emp -> emp.getSalary() > 75000));
```

### **Q8: Explain reduce() operation with examples.**

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// Basic reduce - sum of all numbers
Optional<Integer> sum1 = numbers.stream()
    .reduce((a, b) -> a + b);

// Reduce with identity - won't return Optional
Integer sum2 = numbers.stream()
    .reduce(0, (a, b) -> a + b);

// Using method reference
Integer sum3 = numbers.stream()
    .reduce(0, Integer::sum);

// Find maximum
Optional<Integer> max = numbers.stream()
    .reduce(Integer::max);

// String concatenation
List<String> words = Arrays.asList("Hello", "World", "Java", "Streams");
String concatenated = words.stream()
    .reduce("", (a, b) -> a + " " + b);

// Complex reduce - calculate total salary
List<Employee> employees = getEmployees();
int totalSalary = employees.stream()
    .map(Employee::getSalary)
    .reduce(0, Integer::sum);

// Alternative using mapToInt (more efficient)
int totalSalaryInt = employees.stream()
    .mapToInt(Employee::getSalary)
    .sum();

// Reduce with three parameters (combiner for parallel streams)
String result = Arrays.asList("a", "b", "c", "d").parallelStream()
    .reduce("",
        (identity, element) -> identity + element,    // accumulator
        (partial1, partial2) -> partial1 + partial2   // combiner
    );
```

### **Q9: Finding elements with findFirst(), findAny(), anyMatch(), etc.**

```java
List<Employee> employees = getEmployees();

// Find first employee from IT department
Optional<Employee> firstITEmployee = employees.stream()
    .filter(emp -> "IT".equals(emp.getDepartment()))
    .findFirst();

// Find any employee (useful in parallel streams)
Optional<Employee> anyEmployee = employees.stream()
    .filter(emp -> emp.getSalary() > 80000)
    .findAny();

// Check if any employee has salary > 100000
boolean hasHighSalary = employees.stream()
    .anyMatch(emp -> emp.getSalary() > 100000);

// Check if all employees are above 25 years
boolean allAbove25 = employees.stream()
    .allMatch(emp -> emp.getAge() > 25);

// Check if no employee is from "Marketing" department
boolean noMarketing = employees.stream()
    .noneMatch(emp -> "Marketing".equals(emp.getDepartment()));

// Practical usage with Optional
employees.stream()
    .filter(emp -> "CEO".equals(emp.getDepartment()))
    .findFirst()
    .ifPresent(ceo -> System.out.println("CEO found: " + ceo.getName()))
    .orElse(() -> System.out.println("No CEO found"));

// Using Optional with default values
String ceoName = employees.stream()
    .filter(emp -> "CEO".equals(emp.getDepartment()))
    .map(Employee::getName)
    .findFirst()
    .orElse("No CEO");
```

---

## 🔥 **Advanced Stream Operations**

### **Q10: Working with parallel streams - when and how to use.**

```java
List<Integer> largeList = IntStream.range(1, 1000000)
    .boxed()
    .collect(Collectors.toList());

// Sequential processing
long start = System.currentTimeMillis();
long sequentialSum = largeList.stream()
    .mapToLong(Integer::longValue)
    .sum();
long sequentialTime = System.currentTimeMillis() - start;

// Parallel processing
start = System.currentTimeMillis();
long parallelSum = largeList.parallelStream()
    .mapToLong(Integer::longValue)
    .sum();
long parallelTime = System.currentTimeMillis() - start;

System.out.println("Sequential: " + sequentialTime + "ms");
System.out.println("Parallel: " + parallelTime + "ms");

/* 
When to use Parallel Streams:
✅ Large datasets (thousands+ elements)
✅ CPU-intensive operations
✅ Independent operations (no shared state)
✅ Operations that can be decomposed

When NOT to use:
❌ Small datasets (overhead > benefit)
❌ I/O operations (threads will be blocked)
❌ Operations that modify shared state
❌ Operations that require ordering
*/

// Example: Parallel processing with thread-safe operations
List<String> results = Collections.synchronizedList(new ArrayList<>());

IntStream.range(1, 1000)
    .parallel()
    .forEach(i -> {
        // Simulate processing
        String result = processNumber(i);
        results.add(result); // Thread-safe addition
    });

// Better approach - use collect instead of shared mutable state
List<String> betterResults = IntStream.range(1, 1000)
    .parallel()
    .mapToObj(this::processNumber)
    .collect(Collectors.toList());
```

### **Q11: Custom Collectors - create your own collector.**

```java
// Custom collector to join strings with custom separator
public static Collector<String, ?, String> joining(
    String delimiter, String prefix, String suffix) {
    
    return Collector.of(
        StringBuilder::new,                               // supplier
        (sb, s) -> sb.append(s).append(delimiter),       // accumulator
        (sb1, sb2) -> sb1.append(sb2),                   // combiner
        sb -> prefix + sb.toString() + suffix            // finisher
    );
}

// Usage
List<String> names = Arrays.asList("John", "Jane", "Jack");
String result = names.stream()
    .collect(joining(", ", "[", "]"));
// Result: "[John, Jane, Jack, ]"

// Custom collector to calculate statistics
public static Collector<Employee, ?, Map<String, Object>> employeeStats() {
    return Collector.of(
        () -> new HashMap<String, Object>() {{
            put("count", 0);
            put("totalSalary", 0);
            put("maxSalary", 0);
            put("minSalary", Integer.MAX_VALUE);
        }},
        (map, emp) -> {
            map.put("count", (Integer) map.get("count") + 1);
            map.put("totalSalary", (Integer) map.get("totalSalary") + emp.getSalary());
            map.put("maxSalary", Math.max((Integer) map.get("maxSalary"), emp.getSalary()));
            map.put("minSalary", Math.min((Integer) map.get("minSalary"), emp.getSalary()));
        },
        (map1, map2) -> {
            map1.put("count", (Integer) map1.get("count") + (Integer) map2.get("count"));
            map1.put("totalSalary", (Integer) map1.get("totalSalary") + (Integer) map2.get("totalSalary"));
            map1.put("maxSalary", Math.max((Integer) map1.get("maxSalary"), (Integer) map2.get("maxSalary")));
            map1.put("minSalary", Math.min((Integer) map1.get("minSalary"), (Integer) map2.get("minSalary")));
            return map1;
        }
    );
}

// Usage
Map<String, Object> stats = employees.stream()
    .collect(employeeStats());
```

### **Q12: Working with Optional and Stream integration.**

```java
// Stream of Optionals
List<Optional<String>> optionals = Arrays.asList(
    Optional.of("John"),
    Optional.empty(),
    Optional.of("Jane"),
    Optional.empty(),
    Optional.of("Jack")
);

// Filter out empty optionals and get values
List<String> names = optionals.stream()
    .filter(Optional::isPresent)
    .map(Optional::get)
    .collect(Collectors.toList());

// Java 9+ approach (better)
List<String> namesJava9 = optionals.stream()
    .flatMap(Optional::stream)
    .collect(Collectors.toList());

// Finding first match and handling Optional
Optional<Employee> employee = employees.stream()
    .filter(emp -> emp.getName().startsWith("J"))
    .findFirst();

// Chaining operations with Optional
String department = employee
    .map(Employee::getDepartment)
    .orElse("Unknown");

// Stream from Optional (Java 9+)
Stream<Employee> streamFromOptional = employee.stream();

// Complex Optional chaining
public Optional<String> getEmployeeEmail(String name) {
    return employees.stream()
        .filter(emp -> emp.getName().equals(name))
        .findFirst()
        .map(Employee::getEmail)
        .filter(email -> !email.isEmpty());
}
```

---

## 🚀 **Complex Stream Scenarios - Advanced**

### **Q13: Multi-level grouping and advanced collectors.**

```java
// Complex grouping: Group by department, then by age range
Map<String, Map<String, List<Employee>>> complexGrouping = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.groupingBy(emp -> {
            if (emp.getAge() < 30) return "Young";
            else if (emp.getAge() < 40) return "Middle";
            else return "Senior";
        })
    ));

// Group by department and calculate average salary
Map<String, Double> avgSalaryByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.averagingInt(Employee::getSalary)
    ));

// Group by department and get employee with max salary
Map<String, Optional<Employee>> topEarnerByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.maxBy(Comparator.comparing(Employee::getSalary))
    ));

// Multiple statistics at once
Map<String, IntSummaryStatistics> salaryStatsByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.summarizingInt(Employee::getSalary)
    ));

// Custom downstream collector
Map<String, String> employeeNamesByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.mapping(
            Employee::getName,
            Collectors.joining(", ")
        )
    ));

// Nested collectors with filtering
Map<String, List<Employee>> highEarnersByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.filtering(
            emp -> emp.getSalary() > 70000,
            Collectors.toList()
        )
    ));
```

### **Q14: Stream operations with databases/external APIs.**

```java
// Simulating database repository
class EmployeeRepository {
    public List<Employee> findByDepartment(String dept) {
        // Database call simulation
        return employees.stream()
            .filter(emp -> emp.getDepartment().equals(dept))
            .collect(Collectors.toList());
    }
    
    public Optional<Employee> findById(Long id) {
        // Database call simulation
        return employees.stream()
            .filter(emp -> emp.getId().equals(id))
            .findFirst();
    }
}

EmployeeRepository repository = new EmployeeRepository();

// Stream with database operations
List<String> departmentNames = Arrays.asList("IT", "HR", "Finance");

Map<String, List<Employee>> employeesByDept = departmentNames.stream()
    .collect(Collectors.toMap(
        Function.identity(),
        repository::findByDepartment
    ));

// Parallel processing with external API calls
List<Long> employeeIds = Arrays.asList(1L, 2L, 3L, 4L, 5L);

List<Employee> employeeDetails = employeeIds.parallelStream()
    .map(repository::findById)
    .filter(Optional::isPresent)
    .map(Optional::get)
    .collect(Collectors.toList());

// Error handling in streams
List<Employee> safeEmployeeDetails = employeeIds.stream()
    .map(id -> {
        try {
            return repository.findById(id);
        } catch (Exception e) {
            System.err.println("Error fetching employee " + id + ": " + e.getMessage());
            return Optional.<Employee>empty();
        }
    })
    .filter(Optional::isPresent)
    .map(Optional::get)
    .collect(Collectors.toList());
```

### **Q15: Performance optimization and best practices.**

```java
// Inefficient: Multiple iterations
List<Employee> result1 = employees.stream()
    .filter(emp -> emp.getDepartment().equals("IT"))
    .collect(Collectors.toList());

List<String> result2 = employees.stream()
    .filter(emp -> emp.getDepartment().equals("IT"))
    .map(Employee::getName)
    .collect(Collectors.toList());

// Efficient: Single iteration
Map<Boolean, List<String>> partitioned = employees.stream()
    .filter(emp -> emp.getDepartment().equals("IT"))
    .collect(Collectors.partitioningBy(
        emp -> emp.getSalary() > 75000,
        Collectors.mapping(Employee::getName, Collectors.toList())
    ));

// Use primitive streams when possible
int totalSalary = employees.stream()
    .mapToInt(Employee::getSalary)  // IntStream - more efficient
    .sum();

// Instead of
int totalSalaryInefficient = employees.stream()
    .map(Employee::getSalary)       // Stream<Integer> - boxing overhead
    .reduce(0, Integer::sum);

// Lazy evaluation demonstration
Stream<String> lazyStream = employees.stream()
    .filter(emp -> {
        System.out.println("Filtering: " + emp.getName());
        return emp.getSalary() > 70000;
    })
    .map(emp -> {
        System.out.println("Mapping: " + emp.getName());
        return emp.getName();
    });

System.out.println("Stream created, but no operations executed yet");

// Only now the operations are executed
String firstName = lazyStream.findFirst().orElse("None");

// Short-circuit operations for performance
boolean hasHighEarner = employees.stream()
    .anyMatch(emp -> emp.getSalary() > 100000); // Stops at first match

// Avoid unnecessary object creation
List<String> names = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toList());

// Better: Use method reference and proper collectors
List<String> betterNames = employees.stream()
    .map(Employee::getName)
    .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
```

---

## 🎪 **Tricky Interview Questions**

### **Q16: What will be the output of this code?**

```java
// Question 1
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
numbers.stream()
    .peek(System.out::println)
    .filter(n -> n > 3);

// Output: Nothing! (No terminal operation)

numbers.stream()
    .peek(System.out::println)
    .filter(n -> n > 3)
    .collect(Collectors.toList());

// Output: 1, 2, 3, 4, 5 (peek executes for all elements)

// Question 2
Stream.of("a", "b", "c")
    .map(String::toUpperCase)
    .peek(System.out::println)
    .map(String::toLowerCase)
    .forEach(System.out::println);

// Output: A, a, B, b, C, c

// Question 3: Infinite stream with limit
Stream.iterate(1, n -> n + 1)
    .limit(5)
    .forEach(System.out::println);

// Output: 1, 2, 3, 4, 5

// Question 4: Order of operations
Stream.of(1, 2, 3, 4, 5)
    .filter(n -> {
        System.out.println("filter: " + n);
        return n > 2;
    })
    .map(n -> {
        System.out.println("map: " + n);
        return n * 2;
    })
    .findFirst();

// Output: filter: 1, filter: 2, filter: 3, map: 3
```

### **Q17: Fix the bugs in these stream operations.**

```java
// Bug 1: Modifying source during stream operation
List<String> list = new ArrayList<>(Arrays.asList("a", "b", "c"));
list.stream()
    .forEach(item -> {
        if (item.equals("b")) {
            list.remove(item); // ConcurrentModificationException!
        }
    });

// Fix: Use removeIf or collect to new list
list.removeIf(item -> item.equals("b"));

// Or
List<String> filteredList = list.stream()
    .filter(item -> !item.equals("b"))
    .collect(Collectors.toList());

// Bug 2: Reusing streams
Stream<String> stream = Stream.of("a", "b", "c");
long count = stream.count();
stream.forEach(System.out::println); // IllegalStateException!

// Fix: Create new stream for each operation
Stream<String> stream1 = Stream.of("a", "b", "c");
Stream<String> stream2 = Stream.of("a", "b", "c");
long count = stream1.count();
stream2.forEach(System.out::println);

// Bug 3: Null handling
List<String> listWithNulls = Arrays.asList("a", null, "b", null, "c");
List<String> upperCase = listWithNulls.stream()
    .map(String::toUpperCase) // NullPointerException!
    .collect(Collectors.toList());

// Fix: Filter nulls first
List<String> upperCaseFixed = listWithNulls.stream()
    .filter(Objects::nonNull)
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

### **Q18: Memory and performance gotchas.**

```java
// Memory leak with infinite streams
Stream<String> infiniteStream = Stream.generate(() -> "data");
List<String> list = infiniteStream
    .limit(1000000) // Without limit, OutOfMemoryError!
    .collect(Collectors.toList());

// Inefficient: Creating unnecessary objects
List<Employee> highEarners = employees.stream()
    .filter(emp -> emp.getSalary() > 50000)
    .map(emp -> new Employee(emp.getName(), emp.getDepartment(), 
                            emp.getSalary(), emp.getAge())) // Unnecessary object creation
    .collect(Collectors.toList());

// Efficient: Work with existing objects
List<Employee> efficientHighEarners = employees.stream()
    .filter(emp -> emp.getSalary() > 50000)
    .collect(Collectors.toList());

// Boxing/Unboxing performance impact
// Inefficient
int sum = IntStream.range(1, 1000000)
    .boxed()                    // int -> Integer (boxing)
    .mapToInt(Integer::intValue) // Integer -> int (unboxing)
    .sum();

// Efficient
int efficientSum = IntStream.range(1, 1000000)
    .sum(); // Direct primitive operations
```

---

## 💡 **Real-World Scenarios**

### **Q19: Process large CSV data using streams.**

```java
public class CsvProcessor {
    
    public void processEmployeeCsv(String filePath) throws IOException {
        try (Stream<String> lines = Files.lines(Paths.get(filePath))) {
            Map<String, Double> avgSalaryByDept = lines
                .skip(1) // Skip header
                .map(this::parseEmployee)
                .filter(Objects::nonNull)
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.averagingDouble(Employee::getSalary)
                ));
            
            avgSalaryByDept.forEach((dept, avgSalary) -> 
                System.out.println(dept + ": $" + String.format("%.2f", avgSalary)));
        }
    }
    
    private Employee parseEmployee(String line) {
        try {
            String[] parts = line.split(",");
            return new Employee(
                parts[0].trim(),                    // name
                parts[1].trim(),                    // department
                Integer.parseInt(parts[2].trim()),  // salary
                Integer.parseInt(parts[3].trim())   // age
            );
        } catch (Exception e) {
            System.err.println("Error parsing line: " + line);
            return null;
        }
    }
    
    // Process in chunks for very large files
    public void processLargeCsv(String filePath, int chunkSize) throws IOException {
        try (Stream<String> lines = Files.lines(Paths.get(filePath))) {
            AtomicInteger counter = new AtomicInteger(0);
            
            Collection<List<Employee>> chunks = lines
                .skip(1)
                .map(this::parseEmployee)
                .filter(Objects::nonNull)
                .collect(Collectors.groupingBy(
                    emp -> counter.getAndIncrement() / chunkSize,
                    Collectors.toList()
                ))
                .values();
            
            // Process each chunk
            chunks.forEach(this::processChunk);
        }
    }
    
    private void processChunk(List<Employee> chunk) {
        System.out.println("Processing chunk of size: " + chunk.size());
        // Process the chunk...
    }
}
```

### **Q20: API response transformation using streams.**

```java
// Simulating API responses
class ApiResponse {
    private List<User> users;
    private List<Order> orders;
    
    // getters...
}

class User {
    private Long id;
    private String name;
    private String email;
    private String status;
    
    // constructors, getters...
}

class Order {
    private Long id;
    private Long userId;
    private BigDecimal amount;
    private LocalDateTime orderDate;
    private String status;
    
    // constructors, getters...
}

class UserOrderSummary {
    private String userName;
    private String userEmail;
    private long totalOrders;
    private BigDecimal totalAmount;
    private LocalDateTime lastOrderDate;
    
    // constructors, getters...
}

public class ApiResponseProcessor {
    
    public List<UserOrderSummary> processApiResponse(ApiResponse response) {
        Map<Long, User> userMap = response.getUsers().stream()
            .filter(user -> "ACTIVE".equals(user.getStatus()))
            .collect(Collectors.toMap(User::getId, Function.identity()));
        
        return response.getOrders().stream()
            .filter(order -> "COMPLETED".equals(order.getStatus()))
            .collect(Collectors.groupingBy(Order::getUserId))
            .entrySet().stream()
            .filter(entry -> userMap.containsKey(entry.getKey()))
            .map(entry -> {
                Long userId = entry.getKey();
                List<Order> userOrders = entry.getValue();
                User user = userMap.get(userId);
                
                BigDecimal totalAmount = userOrders.stream()
                    .map(Order::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
                
                LocalDateTime lastOrderDate = userOrders.stream()
                    .map(Order::getOrderDate)
                    .max(LocalDateTime::compareTo)
                    .orElse(null);
                
                return new UserOrderSummary(
                    user.getName(),
                    user.getEmail(),
                    userOrders.size(),
                    totalAmount,
                    lastOrderDate
                );
            })
            .sorted(Comparator.comparing(UserOrderSummary::getTotalAmount).reversed())
            .collect(Collectors.toList());
    }
    
    // Alternative approach using more functional style
    public List<UserOrderSummary> processApiResponseFunctional(ApiResponse response) {
        Map<Long, User> activeUsers = response.getUsers().stream()
            .filter(user -> "ACTIVE".equals(user.getStatus()))
            .collect(Collectors.toMap(User::getId, Function.identity()));
        
        return response.getOrders().stream()
            .filter(order -> "COMPLETED".equals(order.getStatus()))
            .filter(order -> activeUsers.containsKey(order.getUserId()))
            .collect(Collectors.collectingAndThen(
                Collectors.groupingBy(Order::getUserId),
                ordersByUser -> ordersByUser.entrySet().stream()
                    .map(entry -> createUserOrderSummary(entry, activeUsers))
                    .sorted(Comparator.comparing(UserOrderSummary::getTotalAmount).reversed())
                    .collect(Collectors.toList())
            ));
    }
    
    private UserOrderSummary createUserOrderSummary(
            Map.Entry<Long, List<Order>> entry, 
            Map<Long, User> users) {
        
        User user = users.get(entry.getKey());
        List<Order> orders = entry.getValue();
        
        return new UserOrderSummary(
            user.getName(),
            user.getEmail(),
            orders.size(),
            orders.stream().map(Order::getAmount).reduce(BigDecimal.ZERO, BigDecimal::add),
            orders.stream().map(Order::getOrderDate).max(LocalDateTime::compareTo).orElse(null)
        );
    }
}
```

### **Q21: Complex data validation using streams.**

```java
public class DataValidator {
    
    public ValidationResult validateEmployees(List<Employee> employees) {
        List<String> errors = new ArrayList<>();
        
        // Check for duplicate emails
        Set<String> emails = new HashSet<>();
        List<String> duplicateEmails = employees.stream()
            .map(Employee::getEmail)
            .filter(email -> !emails.add(email))
            .distinct()
            .collect(Collectors.toList());
        
        if (!duplicateEmails.isEmpty()) {
            errors.add("Duplicate emails found: " + String.join(", ", duplicateEmails));
        }
        
        // Validate salary ranges by department
        Map<String, IntSummaryStatistics> salaryStats = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.summarizingInt(Employee::getSalary)
            ));
        
        salaryStats.entrySet().stream()
            .filter(entry -> entry.getValue().getMax() > 200000 || 
                           entry.getValue().getMin() < 20000)
            .forEach(entry -> 
                errors.add("Invalid salary range in department: " + entry.getKey()));
        
        // Check for invalid data patterns
        List<String> invalidNames = employees.stream()
            .map(Employee::getName)
            .filter(name -> name == null || name.trim().isEmpty() || 
                          !name.matches("[a-zA-Z\\s]+"))
            .collect(Collectors.toList());
        
        if (!invalidNames.isEmpty()) {
            errors.add("Invalid names found: " + String.join(", ", invalidNames));
        }
        
        // Age validation
        boolean hasInvalidAge = employees.stream()
            .anyMatch(emp -> emp.getAge() < 18 || emp.getAge() > 80);
        
        if (hasInvalidAge) {
            errors.add("Invalid age found (should be between 18 and 80)");
        }
        
        return new ValidationResult(errors.isEmpty(), errors);
    }
    
    // Custom validation with functional interfaces
    public ValidationResult validateWithCustomRules(List<Employee> employees, 
                                                   List<Predicate<Employee>> validationRules,
                                                   List<String> errorMessages) {
        
        List<String> errors = IntStream.range(0, validationRules.size())
            .filter(i -> employees.stream().anyMatch(validationRules.get(i).negate()))
            .mapToObj(errorMessages::get)
            .collect(Collectors.toList());
        
        return new ValidationResult(errors.isEmpty(), errors);
    }
}

class ValidationResult {
    private boolean valid;
    private List<String> errors;
    
    // constructors, getters...
}
```

---

## 🎓 **Interview Tips & Best Practices**

### **Q22: Common mistakes to avoid with streams.**

```java
// ❌ MISTAKE 1: Reusing streams
Stream<String> stream = Stream.of("a", "b", "c");
long count = stream.count();
stream.forEach(System.out::println); // IllegalStateException!

// ✅ CORRECT: Create new stream for each terminal operation
Stream.of("a", "b", "c").count();
Stream.of("a", "b", "c").forEach(System.out::println);

// ❌ MISTAKE 2: Modifying source during stream operation  
List<String> list = new ArrayList<>(Arrays.asList("a", "b", "c"));
list.stream().forEach(item -> {
    if (item.equals("b")) {
        list.remove(item); // ConcurrentModificationException!
    }
});

// ✅ CORRECT: Use appropriate methods
list.removeIf(item -> item.equals("b"));

// ❌ MISTAKE 3: Using parallel streams inappropriately
List<String> result = smallList.parallelStream() // Overhead > benefit
    .map(String::toUpperCase)
    .collect(Collectors.toList());

// ✅ CORRECT: Use parallel streams for large datasets and CPU-intensive tasks
List<String> result = largeList.parallelStream()
    .map(this::cpuIntensiveOperation)
    .collect(Collectors.toList());

// ❌ MISTAKE 4: Not handling nulls
List<String> nullableStrings = Arrays.asList("a", null, "b");
List<String> upperCase = nullableStrings.stream()
    .map(String::toUpperCase) // NullPointerException!
    .collect(Collectors.toList());

// ✅ CORRECT: Filter nulls or handle them
List<String> upperCase = nullableStrings.stream()
    .filter(Objects::nonNull)
    .map(String::toUpperCase)
    .collect(Collectors.toList());

// ❌ MISTAKE 5: Overusing streams for simple operations
List<String> names = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toList());
    
String firstName = names.get(0); // Just to get first name!

// ✅ CORRECT: Direct approach for simple cases
String firstName = employees.isEmpty() ? null : employees.get(0).getName();
```

### **Q23: Performance optimization techniques.**

```java
public class StreamPerformanceOptimization {
    
    // ❌ INEFFICIENT: Multiple stream iterations
    public void inefficientProcessing(List<Employee> employees) {
        List<Employee> itEmployees = employees.stream()
            .filter(emp -> "IT".equals(emp.getDepartment()))
            .collect(Collectors.toList());
            
        List<String> itEmployeeNames = employees.stream()
            .filter(emp -> "IT".equals(emp.getDepartment()))
            .map(Employee::getName)
            .collect(Collectors.toList());
            
        double avgSalary = employees.stream()
            .filter(emp -> "IT".equals(emp.getDepartment()))
            .mapToInt(Employee::getSalary)
            .average()
            .orElse(0.0);
    }
    
    // ✅ EFFICIENT: Single stream iteration with proper collectors
    public void efficientProcessing(List<Employee> employees) {
        List<Employee> itEmployees = employees.stream()
            .filter(emp -> "IT".equals(emp.getDepartment()))
            .collect(Collectors.toList());
            
        // Now work with the filtered list
        List<String> itEmployeeNames = itEmployees.stream()
            .map(Employee::getName)
            .collect(Collectors.toList());
            
        double avgSalary = itEmployees.stream()
            .mapToInt(Employee::getSalary)
            .average()
            .orElse(0.0);
    }
    
    // ✅ EVEN BETTER: Combined collection
    public class ITDepartmentSummary {
        private List<Employee> employees;
        private List<String> names;
        private double avgSalary;
        
        // constructor, getters...
    }
    
    public ITDepartmentSummary bestProcessing(List<Employee> employees) {
        List<Employee> itEmployees = employees.stream()
            .filter(emp -> "IT".equals(emp.getDepartment()))
            .collect(Collectors.toList());
            
        if (itEmployees.isEmpty()) {
            return new ITDepartmentSummary(Collections.emptyList(), 
                                         Collections.emptyList(), 0.0);
        }
        
        List<String> names = itEmployees.stream()
            .map(Employee::getName)
            .collect(Collectors.toList());
            
        double avgSalary = itEmployees.stream()
            .mapToInt(Employee::getSalary)
            .average()
            .orElse(0.0);
            
        return new ITDepartmentSummary(itEmployees, names, avgSalary);
    }
    
    // Use primitive streams when possible
    // ❌ INEFFICIENT: Boxing/Unboxing
    public double inefficientSum(List<Integer> numbers) {
        return numbers.stream()
            .map(n -> n * 2)           // Integer -> Integer (boxing)
            .mapToDouble(Integer::doubleValue) // Integer -> double (unboxing)
            .sum();
    }
    
    // ✅ EFFICIENT: Primitive streams
    public double efficientSum(List<Integer> numbers) {
        return numbers.stream()
            .mapToInt(Integer::intValue)  // Stream<Integer> -> IntStream
            .map(n -> n * 2)              // int -> int (no boxing)
            .sum();                       // primitive sum
    }
}
```

### **Q24: When NOT to use streams.**

```java
public class WhenNotToUseStreams {
    
    // ❌ DON'T use streams for simple iterations
    // Traditional loop is clearer and more efficient
    public void printAllNames(List<Employee> employees) {
        // Stream overkill
        employees.stream().forEach(emp -> System.out.println(emp.getName()));
        
        // Better: simple for-each loop
        for (Employee emp : employees) {
            System.out.println(emp.getName());
        }
    }
    
    // ❌ DON'T use streams when you need early termination with complex logic
    public Employee findEmployeeComplex(List<Employee> employees) {
        // Stream approach - not ideal
        return employees.stream()
            .filter(emp -> {
                if (emp.getDepartment().equals("IT")) {
                    if (emp.getSalary() > 75000) {
                        if (emp.getAge() < 35) {
                            // Complex validation logic...
                            return validateEmployee(emp);
                        }
                    }
                }
                return false;
            })
            .findFirst()
            .orElse(null);
            
        // Better: traditional loop with early return
        for (Employee emp : employees) {
            if (emp.getDepartment().equals("IT") && 
                emp.getSalary() > 75000 && 
                emp.getAge() < 35) {
                if (validateEmployee(emp)) {
                    return emp; // Early termination
                }
            }
        }
        return null;
    }
    
    // ❌ DON'T use streams for small collections (< 100 elements)
    // with simple operations - overhead is not worth it
    
    // ❌ DON'T use parallel streams for I/O operations
    public void badParallelStreamUsage(List<String> urls) {
        List<String> contents = urls.parallelStream() // BAD!
            .map(this::fetchUrlContent) // I/O operation
            .collect(Collectors.toList());
    }
    
    // ✅ Better: Use CompletableFuture for async I/O
    public CompletableFuture<List<String>> goodAsyncProcessing(List<String> urls) {
        List<CompletableFuture<String>> futures = urls.stream()
            .map(url -> CompletableFuture.supplyAsync(() -> fetchUrlContent(url)))
            .collect(Collectors.toList());
            
        return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]))
            .thenApply(v -> futures.stream()
                .map(CompletableFuture::join)
                .collect(Collectors.toList()));
    }
    
    private boolean validateEmployee(Employee emp) {
        // Complex validation logic
        return true;
    }
    
    private String fetchUrlContent(String url) {
        // Simulate I/O operation
        return "content";
    }
}
```

---

## 🏆 **Expert Level Questions**

### **Q25: Create a custom stream implementation.**

```java
// Custom stream for processing data with specific business logic
public class BusinessDataStream<T> {
    private final Stream<T> stream;
    
    private BusinessDataStream(Stream<T> stream) {
        this.stream = stream;
    }
    
    public static <T> BusinessDataStream<T> of(Collection<T> collection) {
        return new BusinessDataStream<>(collection.stream());
    }
    
    // Custom operation: filter with logging
    public BusinessDataStream<T> filterWithLogging(Predicate<T> predicate, String logMessage) {
        return new BusinessDataStream<>(stream.filter(item -> {
            boolean result = predicate.test(item);
            if (!result) {
                System.out.println(logMessage + ": " + item);
            }
            return result;
        }));
    }
    
    // Custom operation: batch processing
    public <R> Stream<List<R>> processBatches(int batchSize, Function<List<T>, List<R>> processor) {
        List<T> items = stream.collect(Collectors.toList());
        List<List<R>> batches = new ArrayList<>();
        
        for (int i = 0; i < items.size(); i += batchSize) {
            int end = Math.min(i + batchSize, items.size());
            List<T> batch = items.subList(i, end);
            batches.add(processor.apply(batch));
        }
        
        return batches.stream();
    }
    
    // Custom operation: retry mechanism
    public <R> BusinessDataStream<R> mapWithRetry(Function<T, R> mapper, int maxRetries) {
        return new BusinessDataStream<>(stream.map(item -> {
            for (int attempt = 0; attempt <= maxRetries; attempt++) {
                try {
                    return mapper.apply(item);
                } catch (Exception e) {
                    if (attempt == maxRetries) {
                        throw new RuntimeException("Max retries exceeded for: " + item, e);
                    }
                    System.out.println("Retry attempt " + (attempt + 1) + " for: " + item);
                }
            }
            return null; // Should never reach here
        }));
    }
    
    // Terminal operation
    public <R, A> R collect(Collector<? super T, A, R> collector) {
        return stream.collect(collector);
    }
    
    public List<T> toList() {
        return stream.collect(Collectors.toList());
    }
    
    public Stream<T> stream() {
        return stream;
    }
}

// Usage example
List<Employee> employees = getEmployees();
List<Employee> processedEmployees = BusinessDataStream.of(employees)
    .filterWithLogging(emp -> emp.getSalary() > 50000, "Low salary filtered")
    .mapWithRetry(this::enrichEmployee, 3)
    .toList();
```

### **Q26: Implement a streaming data processor with backpressure handling.**

```java
public class StreamingProcessor<T, R> {
    private final int bufferSize;
    private final Function<T, R> processor;
    private final Queue<T> buffer;
    private final AtomicInteger processedCount = new AtomicInteger(0);
    
    public StreamingProcessor(int bufferSize, Function<T, R> processor) {
        this.bufferSize = bufferSize;
        this.processor = processor;
        this.buffer = new ArrayBlockingQueue<>(bufferSize);
    }
    
    public Stream<R> process(Stream<T> inputStream) {
        return inputStream
            .peek(this::handleBackpressure)
            .map(processor)
            .peek(result -> processedCount.incrementAndGet());
    }
    
    private void handleBackpressure(T item) {
        if (buffer.size() >= bufferSize) {
            // Apply backpressure - slow down or drop items
            System.out.println("Backpressure applied. Buffer size: " + buffer.size());
            try {
                Thread.sleep(10); // Slow down processing
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        buffer.offer(item);
    }
    
    public CompletableFuture<List<R>> processAsync(Stream<T> inputStream) {
        return CompletableFuture.supplyAsync(() -> 
            inputStream
                .parallel()
                .map(processor)
                .collect(Collectors.toList())
        );
    }
    
    public int getProcessedCount() {
        return processedCount.get();
    }
}
```

---

## 🎯 **Quick Reference & Cheat Sheet**

### **Stream Operations Summary**

```java
// CREATION
Stream.of(1, 2, 3)
Arrays.stream(array)
collection.stream()
Files.lines(path)

// INTERMEDIATE (return Stream)
filter(predicate)          // Filter elements
map(function)              // Transform elements  
flatMap(function)          // Flatten nested structures
distinct()                 // Remove duplicates
sorted()                   // Sort elements
limit(n)                   // Take first n elements
skip(n)                    // Skip first n elements
peek(consumer)             // Side effect operation

// TERMINAL (return result)
collect(collector)         // Collect to collection
forEach(consumer)          // Iterate elements
reduce(accumulator)        // Reduce to single value
count()                    // Count elements
findFirst()                // Get first element
findAny()                  // Get any element
anyMatch(predicate)        // Check if any matches
allMatch(predicate)        // Check if all match
noneMatch(predicate)       // Check if none match

// COLLECTORS
toList()                   // To List
toSet()                    // To Set
toMap(keyMapper, valueMapper) // To Map
groupingBy(classifier)     // Group by key
partitioningBy(predicate)  // Partition by boolean
joining(delimiter)         // Join to String
counting()                 // Count elements
averagingInt(mapper)       // Average
summarizingInt(mapper)     // Statistics
```

### **Performance Guidelines**

```java
✅ DO:
- Use primitive streams (IntStream, LongStream, DoubleStream)
- Chain operations efficiently
- Use parallel streams for large datasets and CPU-intensive operations
- Use appropriate collectors
- Filter early in the pipeline

❌ DON'T:
- Reuse streams
- Modify source during stream operations
- Use parallel streams for I/O operations
- Use streams for simple iterations
- Ignore null handling

🔥 PERFORMANCE TIPS:
- filter() before map() for better performance
- Use findFirst() or findAny() instead of collecting all
- Prefer method references over lambda expressions
- Use short-circuit operations when possible
```

---

## 🎤 **Final Interview Tips**

### **What Interviewers Look For:**

1. **Understanding of functional programming concepts**
2. **Knowledge of when to use vs not use streams**
3. **Performance implications and optimization**
4. **Proper error handling**
5. **Real-world application scenarios**

### **Common Follow-up Questions:**

- "How would you optimize this stream operation?"
- "What happens if this stream operation throws an exception?"
- "How would you handle null values in this stream?"
- "Can you rewrite this using traditional loops? Which is better?"
- "How would you make this stream operation thread-safe?"

### **Practice Strategy:**

1. **Code daily** - Write stream operations for different scenarios
2. **Benchmark performance** - Compare streams vs traditional loops
3. **Read source code** - Study Java 8+ Stream API implementation
4. **Solve real problems** - Use streams in actual projects
5. **Practice explaining** - Teach concepts to others

---

**Remember: Streams are powerful but not always the right choice. Show that you understand both the capabilities and limitations!** 🚀