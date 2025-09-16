# Java Streams Theory

## Table of Contents
1. [Introduction to Streams](#introduction-to-streams)
   - [What are Streams?](#what-are-streams)
   - [Why Streams in Java?](#why-streams-in-java)
   - [Stream vs Collection](#stream-vs-collection)

2. [Stream Creation](#stream-creation)
   - [From Collections](#from-collections)
   - [From Arrays](#from-arrays)
   - [From Static Factory Methods](#from-static-factory-methods)
   - [From File I/O](#from-file-io)
   - [Infinite Streams](#infinite-streams)

3. [Stream Operations](#stream-operations)
   - [Intermediate Operations](#intermediate-operations)
   - [Terminal Operations](#terminal-operations)
   - [Short-Circuiting Operations](#short-circuiting-operations)

4. [Intermediate Operations in Detail](#intermediate-operations-in-detail)
   - [filter()](#filter)
   - [map()](#map)
   - [flatMap()](#flatmap)
   - [distinct()](#distinct)
   - [sorted()](#sorted)
   - [peek()](#peek)
   - [limit() and skip()](#limit-and-skip)

5. [Terminal Operations in Detail](#terminal-operations-in-detail)
   - [forEach()](#foreach)
   - [collect()](#collect)
   - [reduce()](#reduce)
   - [min(), max(), count()](#min-max-count)
   - [anyMatch(), allMatch(), noneMatch()](#anymatch-allmatch-nonematch)
   - [findFirst() and findAny()](#findfirst-and-findany)

6. [Collectors](#collectors)
   - [toList()](#tolist) - For collecting elements into a List
   - [toSet()](#toset) - For collecting elements into a Set with duplicates removed
   - [toMap()](#tomap) - For transforming elements into key-value pairs
   - [joining()](#joining) - For concatenating elements with various delimiter options
   - [counting()](#counting) - For counting stream elements
   - [summarizingInt/Long/Double()](#summarizingintlongdouble) - For obtaining statistics on numeric data
   - [mapping()](#mapping) - For transforming elements before collection
   - [flatMapping()](#flatmapping) - For flattens nested structures into a single stream before collection.
   - [groupingBy()](#groupingby) - For classifying elements into groups
   - [partitioningBy()](#partitioningby) - For splitting elements based on a predicate
   - [reducing()](#reducing) - For combining elements into a single result
   <!-- - [collectingAndThen()](#collectingandthen) - For performing additional transformations after collection
   - [Basic Collectors](#basic-collectors)
   - [Grouping and Partitioning](#grouping-and-partitioning) -->
   - [Custom Collectors](#custom-collectors)

7. [Parallel Streams](#parallel-streams)
   - [When to Use Parallel Streams](#when-to-use-parallel-streams)
   - [Performance Considerations](#performance-considerations)
   - [Common Pitfalls](#common-pitfalls)

8. [Stream Best Practices](#stream-best-practices)
   - [Efficiency Guidelines](#efficiency-guidelines)
   - [Debugging Streams](#debugging-streams)
   - [Common Anti-patterns](#common-anti-patterns)

9. [Advanced Stream Concepts](#advanced-stream-concepts)
   - [Specialized Streams](#specialized-streams)
   - [Optional with Streams](#optional-with-streams)
   - [Spliterator](#spliterator)

10. [Real-world Examples](#real-world-examples)
    - [Data Processing Pipelines](#data-processing-pipelines)
    - [File Processing](#file-processing)
    - [Database Operations](#database-operations)

11. [Stream Terminology](#stream-terminology)
    - [Key Terms and Interfaces](#key-terms-and-interfaces)

12. [Stream Operations Cheat Sheet](#cheat-sheet)

---

## Stream Terminology

### Key Terms and Interfaces

Understanding the terminology used in Java Streams is essential for mastering this API. Here's a quick reference of important terms:

| **Term**           | **Type / Interface** | **Function**                                     | **Use Case Example**                               |
| ------------------ | -------------------- | ------------------------------------------------ | -------------------------------------------------- |
| **Mapper**         | `Function<T, R>`     | Transforms each element                          | `map(s -> s.length())` — converts string to length |
| **Downstream**     | `Collector`          | A nested collector used inside another collector | `groupingBy(..., counting())`                      |
| **Accumulator**    | `BiConsumer<A, T>`   | Adds an element to a mutable container           | Adding elements to a `List`                        |
| **Supplier**       | `Supplier<A>`        | Creates a new empty container                    | `() -> new ArrayList<>()`                          |
| **Finisher**       | `Function<A, R>`     | Converts the container to the final result       | Making an immutable collection                     |
| **Combiner**       | `BinaryOperator<A>`  | Combines two partial results                     | Used in parallel streams                           |
| **Predicate**      | `Predicate<T>`       | Checks if a condition is true or false           | `filter(s -> s.startsWith("a"))`                   |
| **Comparator**     | `Comparator<T>`      | Compares two elements                            | Sorting, or finding min/max                        |
| **BinaryOperator** | `BinaryOperator<T>`  | Combines two elements of the same type           | `reduce(Integer::sum)`                             |
| **Collector**      | `Interface`          | Defines how to collect elements from a stream    | `Collectors.toList()`                              |
| **Classifier**     | `Function<T, K>`    | Extracts the key for grouping elements           | `groupingBy(Person::getDepartment)`              |

---

## Introduction to Streams

### What are Streams?

A stream in Java is a sequence of elements supporting sequential and parallel aggregate operations. Streams are not a data structure that stores elements; instead, they convey elements from a source through a pipeline of computational operations.

Streams represent a paradigm shift in Java programming, moving from imperative programming (how to do something) to declarative programming (what you want to do).

### Why Streams in Java?

Streams were introduced in Java 8 as part of the Java SE 8 Date/Time API to address several needs:

1. **Declarative Programming**: Express complex data processing queries in a clear, concise manner
2. **Functional Programming Support**: Leverage functional interfaces and lambda expressions
3. **Parallel Processing**: Easily parallelize operations without dealing with threads directly
4. **Lazy Evaluation**: Process data only when needed, improving performance
5. **Pipeline Processing**: Chain multiple operations together efficiently

### Stream vs Collection

| Aspect | Stream | Collection |
|--------|--------|------------|
| Purpose | Data processing | Data storage |
| When computed | On-demand (lazy) | At creation time (eager) |
| Consumption | Can be consumed only once | Can be accessed multiple times |
| External vs Internal iteration | Internal iteration | External iteration |
| Parallel processing | Built-in support | Manual implementation |
| Mutability | Immutable pipeline | Typically mutable |

Example showing the difference:

```java
// Collection approach (external iteration)
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Dave");
List<String> filteredNames = new ArrayList<>();
for (String name : names) {  // External iteration
    if (name.length() > 3) {
        filteredNames.add(name.toUpperCase());
    }
}

// Stream approach (internal iteration)
List<String> filteredNames = names.stream()  // Internal iteration
    .filter(name -> name.length() > 3)
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

---

## Stream Creation

There are multiple ways to create streams in Java:

### From Collections

Any Collection interface can be converted to a stream using the `stream()` method:

```java
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream = list.stream();
```

### From Arrays

Arrays can be converted to streams using `Arrays.stream()`:

```java
String[] array = {"x", "y", "z"};
Stream<String> stream = Arrays.stream(array);

// For primitive arrays
int[] numbers = {1, 2, 3, 4, 5};
IntStream intStream = Arrays.stream(numbers);
```

### From Static Factory Methods

The Stream interface provides several static methods to create streams:

```java
// Stream.of() - create from individual elements
Stream<String> stream = Stream.of("a", "b", "c");

// Stream.builder() - build streams step by step
Stream<String> built = Stream.<String>builder()
    .add("one")
    .add("two")
    .add("three")
    .build();

// Stream.empty() - create an empty stream
Stream<String> emptyStream = Stream.empty();
```

### From File I/O

Java NIO provides methods to create streams from files:

```java
try (Stream<String> lines = Files.lines(Paths.get("file.txt"))) {
    lines.forEach(System.out::println);
}

// Read all lines at once
List<String> allLines = Files.readAllLines(Paths.get("file.txt"));
Stream<String> linesStream = allLines.stream();
```

### Infinite Streams

Java provides methods to create infinite streams:

```java
// Generate infinite sequence of integers starting from 0
Stream<Integer> infiniteIntegers = Stream.iterate(0, n -> n + 1);

// Generate infinite stream of random numbers
Stream<Double> infiniteRandoms = Stream.generate(Math::random);

// Limit infinite streams to make them finite
List<Integer> first10Numbers = infiniteIntegers
    .limit(10)
    .collect(Collectors.toList());
```

---

## Stream Operations

Stream operations are divided into two categories: intermediate and terminal operations.

### Intermediate Operations

Intermediate operations transform a stream into another stream. They are lazy, meaning they don't process the elements until a terminal operation is invoked. Key characteristics:

- Return a new stream
- Don't process data until terminal operation is called
- Can be chained together
- Are lazy - only process what's needed

Common intermediate operations:
- `filter()`: Filters elements based on a predicate
- `map()`: Transforms elements using a function
- `flatMap()`: Transforms and flattens nested streams
- `distinct()`: Removes duplicates
- `sorted()`: Sorts elements
- `peek()`: Performs an action on each element without modifying the stream
- `limit()`: Limits the size of the stream
- `skip()`: Skips a number of elements

### Terminal Operations

Terminal operations produce a result or side-effect from a stream. After a terminal operation is performed, the stream is considered consumed and cannot be reused. Key characteristics:

- Produce a result or side-effect
- Trigger the processing of stream elements
- Can only be used once per stream

Common terminal operations:
- `forEach()`: Performs an action for each element
- `collect()`: Transforms the stream into a different form
- `reduce()`: Reduces the stream to a single value
- `count()`: Counts the elements in the stream
- `anyMatch()`, `allMatch()`, `noneMatch()`: Check if elements match a predicate
- `findFirst()`, `findAny()`: Find an element in the stream
- `min()`, `max()`: Find the minimum or maximum element

### Short-Circuiting Operations

Some operations can terminate the processing early without examining all elements:

- Intermediate short-circuiting operations:
  - `limit(n)`: Limits processing to first n elements
  - `skip(n)`: Skips first n elements

- Terminal short-circuiting operations:
  - `anyMatch()`: Returns as soon as a matching element is found
  - `findFirst()`: Returns the first element and stops
  - `findAny()`: Returns any element and stops

---

## Intermediate Operations in Detail

### filter()

The `filter()` operation selects elements based on a predicate (boolean-valued function):

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

List<Integer> evenNumbers = numbers.stream()
    .filter(n -> n % 2 == 0)  // Keep only even numbers
    .collect(Collectors.toList());
// Result: [2, 4, 6, 8, 10]
```

### map()

The `map()` operation transforms each element using a function:

```java
List<String> words = Arrays.asList("hello", "world");

List<String> upperCaseWords = words.stream()
    .map(String::toUpperCase)  // Transform to uppercase
    .collect(Collectors.toList());
// Result: ["HELLO", "WORLD"]

List<Integer> wordLengths = words.stream()
    .map(String::length)  // Transform to length
    .collect(Collectors.toList());
// Result: [5, 5]
```

### flatMap()

The `flatMap()` operation transforms each element into a stream and then flattens the resulting streams into a single stream:

```java
List<List<Integer>> nestedLists = Arrays.asList(
    Arrays.asList(1, 2, 3),
    Arrays.asList(4, 5, 6),
    Arrays.asList(7, 8, 9)
);

List<Integer> flattenedList = nestedLists.stream()
    .flatMap(Collection::stream)  // Flatten nested lists
    .collect(Collectors.toList());
// Result: [1, 2, 3, 4, 5, 6, 7, 8, 9]

// Real-world example: Get all unique words from multiple sentences
List<String> sentences = Arrays.asList(
    "Hello world",
    "Java streams are powerful",
    "Streams process data"
);

List<String> uniqueWords = sentences.stream()
    .flatMap(sentence -> Arrays.stream(sentence.toLowerCase().split(" ")))
    .distinct()
    .collect(Collectors.toList());
// Result: ["hello", "world", "java", "streams", "are", "powerful", "process", "data"]
```

### distinct()

The `distinct()` operation returns a stream with duplicate elements removed:

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 2, 1, 3, 4, 5, 4);

List<Integer> distinctNumbers = numbers.stream()
    .distinct()  // Remove duplicates
    .collect(Collectors.toList());
// Result: [1, 2, 3, 4, 5]
```

### sorted()

The `sorted()` operation sorts the elements of the stream:

```java
List<String> names = Arrays.asList("John", "Alice", "Bob", "Charlie");

// Natural order sorting
List<String> sortedNames = names.stream()
    .sorted()  // Sort alphabetically
    .collect(Collectors.toList());
// Result: ["Alice", "Bob", "Charlie", "John"]

// Custom sorting
List<String> sortedByLength = names.stream()
    .sorted(Comparator.comparing(String::length))  // Sort by length
    .collect(Collectors.toList());
// Result: ["Bob", "John", "Alice", "Charlie"]

// Reverse sorting
List<String> reverseSorted = names.stream()
    .sorted(Comparator.reverseOrder())  // Sort in reverse
    .collect(Collectors.toList());
// Result: ["John", "Charlie", "Bob", "Alice"]
```

### peek()

The `peek()` operation performs an action on each element as it is processed, without modifying the stream. It's useful for debugging:

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

List<Integer> result = numbers.stream()
    .peek(n -> System.out.println("Processing: " + n))  // Debug output
    .map(n -> n * 2)
    .peek(n -> System.out.println("Mapped to: " + n))  // Debug output
    .collect(Collectors.toList());
// Result: [2, 4, 6, 8, 10]
```

### limit() and skip()

The `limit()` operation truncates the stream to a maximum size, while `skip()` discards the first n elements:

```java
List<Integer> numbers = IntStream.rangeClosed(1, 10)
    .boxed()
    .collect(Collectors.toList());

// Get first 5 elements
List<Integer> first5 = numbers.stream()
    .limit(5)  // Take only first 5
    .collect(Collectors.toList());
// Result: [1, 2, 3, 4, 5]

// Skip first 5 elements
List<Integer> last5 = numbers.stream()
    .skip(5)  // Skip first 5
    .collect(Collectors.toList());
// Result: [6, 7, 8, 9, 10]

// Pagination example
int pageSize = 3;
int pageNumber = 2;  // 0-based

List<Integer> page = numbers.stream()
    .skip(pageNumber * pageSize)
    .limit(pageSize)
    .collect(Collectors.toList());
// Result: [7, 8, 9]
```

---

## Terminal Operations in Detail

### forEach()

The `forEach()` operation performs an action for each element in the stream:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Simple iteration
names.stream()
    .forEach(name -> System.out.println("Hello, " + name));

// Using method reference
names.stream()
    .forEach(System.out::println);
```

### collect()

The `collect()` operation transforms the elements of the stream into a different form, often a collection:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Collect to List
List<String> namesList = names.stream()
    .collect(Collectors.toList());

// Collect to Set
Set<String> namesSet = names.stream()
    .collect(Collectors.toSet());

// Collect to specific collection implementation
ArrayList<String> namesArrayList = names.stream()
    .collect(Collectors.toCollection(ArrayList::new));

// Collect to String
String joinedNames = names.stream()
    .collect(Collectors.joining(", "));
// Result: "Alice, Bob, Charlie"

// Collect to Map
Map<String, Integer> nameLengthMap = names.stream()
    .collect(Collectors.toMap(
        Function.identity(),  // Key: name
        String::length        // Value: length
    ));
// Result: {"Alice"=5, "Bob"=3, "Charlie"=7}
```

### reduce()

The `reduce()` operation combines the elements of the stream into a single result:

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// Sum using reduce
Optional<Integer> sum = numbers.stream()
    .reduce((a, b) -> a + b);
// Result: Optional[15]

// Sum with identity value
Integer sum2 = numbers.stream()
    .reduce(0, (a, b) -> a + b);
// Result: 15

// Using method reference
Integer sum3 = numbers.stream()
    .reduce(0, Integer::sum);
// Result: 15

// Find maximum value
Optional<Integer> max = numbers.stream()
    .reduce(Integer::max);
// Result: Optional[5]

// String concatenation
String concatenated = Stream.of("a", "b", "c")
    .reduce("", (a, b) -> a + b);
// Result: "abc"
```

### min(), max(), count()

These operations find the minimum/maximum element or count the elements in the stream:

```java
List<Integer> numbers = Arrays.asList(5, 2, 8, 1, 9, 3);

// Find minimum
Optional<Integer> min = numbers.stream()
    .min(Integer::compare);
// Result: Optional[1]

// Find maximum
Optional<Integer> max = numbers.stream()
    .max(Integer::compare);
// Result: Optional[9]

// Count elements
long count = numbers.stream()
    .count();
// Result: 6

// Count with filter
long evenCount = numbers.stream()
    .filter(n -> n % 2 == 0)
    .count();
// Result: 2
```

### anyMatch(), allMatch(), noneMatch()

These operations check if elements match a given predicate:

```java
List<Integer> numbers = Arrays.asList(2, 4, 6, 8, 10);

// Check if any element is even
boolean hasEven = numbers.stream()
    .anyMatch(n -> n % 2 == 0);
// Result: true

// Check if all elements are even
boolean allEven = numbers.stream()
    .allMatch(n -> n % 2 == 0);
// Result: true

// Check if no element is odd
boolean noOdd = numbers.stream()
    .noneMatch(n -> n % 2 != 0);
// Result: true

// Real-world example: Validation
List<String> passwords = Arrays.asList("Abc123!", "password", "Secret99");

boolean allStrongPasswords = passwords.stream()
    .allMatch(p -> p.length() >= 8 && 
              p.matches(".*[A-Z].*") && 
              p.matches(".*[0-9].*"));
// Result: false
```

### findFirst() and findAny()

These operations find an element in the stream:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Dave");

// Find first element
Optional<String> first = names.stream()
    .findFirst();
// Result: Optional["Alice"]

// Find any element (useful in parallel streams)
Optional<String> any = names.stream()
    .findAny();
// Result: Optional["Alice"] (in sequential streams, typically the first)

// Find first element matching condition
Optional<String> firstLongName = names.stream()
    .filter(name -> name.length() > 4)
    .findFirst();
// Result: Optional["Alice"]

// Using Optional methods
String result = names.stream()
    .filter(name -> name.startsWith("Z"))
    .findFirst()
    .orElse("No matching name found");
// Result: "No matching name found"
```

---

## Collectors

Collectors are used with the `collect()` terminal operation to transform elements into a different form.

### Collector Methods in Detail

#### toList()

For collecting elements into a List:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Collect stream elements into a List
List<String> namesList = names.stream()
    .filter(name -> name.length() > 3)
    .collect(Collectors.toList());
// Result: [Alice, Charlie]
```

#### toSet()

For collecting elements into a Set with duplicates removed:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Alice", "Charlie");

// Collect stream elements into a Set (removes duplicates)
Set<String> uniqueNames = names.stream()
    .collect(Collectors.toSet());
// Result: [Alice, Bob, Charlie]
```

#### toMap()

For transforming elements into key-value pairs:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Basic toMap with key and value functions
Map<String, Integer> nameLengthMap = names.stream()
    .collect(Collectors.toMap(
        Function.identity(),  // Key: name itself
        String::length        // Value: length of name
    ));
// Result: {Alice=5, Bob=3, Charlie=7}

// toMap with merge function to handle duplicate keys
List<Person> people = Arrays.asList(
    new Person("IT", "Alice", 80000),
    new Person("IT", "Bob", 70000),
    new Person("HR", "Charlie", 75000)
);

Map<String, Person> highestPaidByDept = people.stream()
    .collect(Collectors.toMap(
        Person::getDepartment,          // Key: department
        Function.identity(),            // Value: person object
        (existing, replacement) ->      // Merge function for duplicates
            existing.getSalary() > replacement.getSalary() 
                ? existing : replacement
    ));
// Result: {IT=Person(Alice, 80000), HR=Person(Charlie, 75000)}
```

#### joining()

For concatenating elements with various delimiter options:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Basic joining with delimiter
String joined = names.stream()
    .collect(Collectors.joining(", "));
// Result: "Alice, Bob, Charlie"

// Joining with prefix and suffix
String joinedWithBrackets = names.stream()
    .collect(Collectors.joining(", ", "[", "]"));
// Result: "[Alice, Bob, Charlie]"

// Joining with map transformation
String uppercaseJoined = names.stream()
    .map(String::toUpperCase)
    .collect(Collectors.joining(" | "));
// Result: "ALICE | BOB | CHARLIE"
```

#### counting()

For counting stream elements:

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// Count elements in a stream
long count = names.stream()
    .collect(Collectors.counting());
// Result: 3

// Counting with filtering
long countStartingWithA = names.stream()
    .filter(name -> name.startsWith("A"))
    .collect(Collectors.counting());
// Result: 1
```

#### summarizingInt/Long/Double()

For obtaining statistics on numeric data:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25),
    new Person("Bob", 30),
    new Person("Charlie", 35)
);

// Get statistics on ages
IntSummaryStatistics ageStats = people.stream()
    .collect(Collectors.summarizingInt(Person::getAge));

// Access individual statistics
long count = ageStats.getCount();       // 3
long sum = ageStats.getSum();           // 90
int min = ageStats.getMin();            // 25
int max = ageStats.getMax();            // 35
double average = ageStats.getAverage(); // 30.0

// Similarly for double values
DoubleSummaryStatistics salaryStats = people.stream()
    .collect(Collectors.summarizingDouble(Person::getSalary));
```

#### mapping()

For transforming elements before collection:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25),
    new Person("Bob", 30),
    new Person("Charlie", 35)
);

// Extract and collect names
List<String> names = people.stream()
    .collect(Collectors.mapping(
        Person::getName,
        Collectors.toList()
    ));
// Result: [Alice, Bob, Charlie]

// Transform and join names
String uppercaseNames = people.stream()
    .collect(Collectors.mapping(
        person -> person.getName().toUpperCase(),
        Collectors.joining(", ")
    ));
// Result: "ALICE, BOB, CHARLIE"
```
#### flatMapping()

when the transformation function returns a stream or collection. This flattens nested structures into a single stream before collection.

```java
class Order {
    String customer;
    List<String> items;
    // constructors, getters...
}

List<Order> orders = Arrays.asList(
    new Order("Alice", Arrays.asList("laptop", "mouse")),
    new Order("Bob", Arrays.asList("keyboard")),
    new Order("Alice", Arrays.asList("monitor", "cable"))
);

// Flatten items by customer (this was missing in original)
Map<String, List<String>> allItemsByCustomer = orders.stream()
    .collect(Collectors.groupingBy(
        Order::getCustomer,
        Collectors.flatMapping(
            order -> order.getItems().stream(),
            Collectors.toList()
        )
    ));
// {Alice=[laptop, mouse, monitor, cable], Bob=[keyboard]}

// Compare with mapping() - gives nested structure
Map<String, List<List<String>>> nestedItems = orders.stream()
    .collect(Collectors.groupingBy(
        Order::getCustomer,
        Collectors.mapping(Order::getItems, Collectors.toList())
    ));
// {Alice=[[laptop, mouse], [monitor, cable]], Bob=[[keyboard]]}
```

#### groupingBy()

For classifying elements into groups:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25, "IT"),
    new Person("Bob", 30, "HR"),
    new Person("Charlie", 35, "IT"),
    new Person("Dave", 40, "HR")
);

// Basic grouping by department
Map<String, List<Person>> byDepartment = people.stream()
    .collect(Collectors.groupingBy(Person::getDepartment));
// Result: {IT=[Alice, Charlie], HR=[Bob, Dave]}

// Grouping with downstream collector
Map<String, Long> countByDepartment = people.stream()
    .collect(Collectors.groupingBy(
        Person::getDepartment,
        Collectors.counting()
    ));
// Result: {IT=2, HR=2}

// Multi-level grouping
Map<String, Map<Integer, List<Person>>> byDeptAndAge = people.stream()
    .collect(Collectors.groupingBy(
        Person::getDepartment,
        Collectors.groupingBy(
            person -> person.getAge() / 10 * 10  // Age groups by decade
        )
    ));
// Result: {IT={20=[Alice], 30=[Charlie]}, HR={30=[Bob], 40=[Dave]}}
```

#### partitioningBy()

For splitting elements based on a predicate:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25),
    new Person("Bob", 30),
    new Person("Charlie", 35),
    new Person("Dave", 40)
);

// Basic partitioning by age
Map<Boolean, List<Person>> partitionedByAge = people.stream()
    .collect(Collectors.partitioningBy(p -> p.getAge() > 30));
// Result: {false=[Alice, Bob], true=[Charlie, Dave]}

// Partitioning with downstream collector
Map<Boolean, Long> countByAgeGroup = people.stream()
    .collect(Collectors.partitioningBy(
        p -> p.getAge() > 30,
        Collectors.counting()
    ));
// Result: {false=2, true=2}

// Partitioning with mapping
Map<Boolean, List<String>> namesByAgeGroup = people.stream()
    .collect(Collectors.partitioningBy(
        p -> p.getAge() > 30,
        Collectors.mapping(Person::getName, Collectors.toList())
    ));
// Result: {false=[Alice, Bob], true=[Charlie, Dave]}
```

#### reducing()

For combining elements into a single result:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25, 50000),
    new Person("Bob", 30, 60000),
    new Person("Charlie", 35, 70000)
);

// Sum of salaries
Optional<Integer> totalSalary = people.stream()
    .map(Person::getSalary)
    .collect(Collectors.reducing(Integer::sum));
// Result: Optional[180000]

// With identity value (no Optional result)
int totalSalaryWithIdentity = people.stream()
    .collect(Collectors.reducing(
        0,                  // Identity value
        Person::getSalary,  // Value mapper
        Integer::sum        // Reducer function
    ));
// Result: 180000

// Find person with highest salary
Optional<Person> highestPaid = people.stream()
    .collect(Collectors.reducing(
        (p1, p2) -> p1.getSalary() > p2.getSalary() ? p1 : p2
    ));
// Result: Optional[Person(Charlie, 35, 70000)]
```

#### collectingAndThen()

For performing additional transformations after collection:

```java
List<Person> people = Arrays.asList(
    new Person("Alice", 25),
    new Person("Bob", 30),
    new Person("Charlie", 35)
);

// Collect to list and make it unmodifiable
List<String> names = people.stream()
    .map(Person::getName)
    .collect(Collectors.collectingAndThen(
        Collectors.toList(),
        Collections::unmodifiableList
    ));
// Result: Unmodifiable list [Alice, Bob, Charlie]

// Find the oldest person
Person oldest = people.stream()
    .collect(Collectors.collectingAndThen(
        Collectors.maxBy(Comparator.comparing(Person::getAge)),
        optional -> optional.orElseThrow(() -> new IllegalStateException("No people found"))
    ));
// Result: Person(Charlie, 35)

// Count and convert to string
String countStr = people.stream()
    .collect(Collectors.collectingAndThen(
        Collectors.counting(),
        count -> "There are " + count + " people"
    ));
// Result: "There are 3 people"
```
<!-- 
### Basic Collectors

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Dave");

// To List
List<String> namesList = names.stream()
    .collect(Collectors.toList());

// To Set
Set<String> namesSet = names.stream()
    .collect(Collectors.toSet());

// To Collection
Collection<String> namesCollection = names.stream()
    .collect(Collectors.toCollection(LinkedList::new));

// To Array
String[] namesArray = names.stream()
    .toArray(String[]::new);

// Joining
String joined = names.stream()
    .collect(Collectors.joining(", ", "[", "]"));
// Result: "[Alice, Bob, Charlie, Dave]"

// Counting
long count = names.stream()
    .collect(Collectors.counting());
// Result: 4

// Summarizing
IntSummaryStatistics stats = names.stream()
    .collect(Collectors.summarizingInt(String::length));
// Result: IntSummaryStatistics{count=4, sum=18, min=3, average=4.500000, max=7}
```

### Grouping and Partitioning

```java
class Person {
    private String name;
    private int age;
    private String department;
    
    // Constructor, getters, setters
    public Person(String name, int age, String department) {
        this.name = name;
        this.age = age;
        this.department = department;
    }
    
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getDepartment() { return department; }
}

List<Person> people = Arrays.asList(
    new Person("Alice", 25, "IT"),
    new Person("Bob", 30, "HR"),
    new Person("Charlie", 35, "IT"),
    new Person("Dave", 40, "HR"),
    new Person("Eve", 45, "Finance")
);

// Group by department
Map<String, List<Person>> byDepartment = people.stream()
    .collect(Collectors.groupingBy(Person::getDepartment));
// Result: {IT=[Alice, Charlie], HR=[Bob, Dave], Finance=[Eve]}

// Group by department and count
Map<String, Long> departmentCount = people.stream()
    .collect(Collectors.groupingBy(
        Person::getDepartment,
        Collectors.counting()
    ));
// Result: {IT=2, HR=2, Finance=1}

// Group by department and get names
Map<String, List<String>> departmentNames = people.stream()
    .collect(Collectors.groupingBy(
        Person::getDepartment,
        Collectors.mapping(Person::getName, Collectors.toList())
    ));
// Result: {IT=[Alice, Charlie], HR=[Bob, Dave], Finance=[Eve]}

// Partition by age
Map<Boolean, List<Person>> partitionedByAge = people.stream()
    .collect(Collectors.partitioningBy(p -> p.getAge() > 30));
// Result: {false=[Alice, Bob], true=[Charlie, Dave, Eve]}
``` -->

### Custom Collectors

```java
// Custom collector to join strings with custom separator
public static <T> Collector<T, ?, String> joinWithPrefixSuffix(
        Function<T, String> mapper,
        String delimiter,
        String prefix,
        String suffix) {
    
    return Collector.of(
        StringBuilder::new,
        (sb, item) -> {
            if (sb.length() > 0) {
                sb.append(delimiter);
            }
            sb.append(mapper.apply(item));
        },
        (sb1, sb2) -> {
            if (sb1.length() > 0 && sb2.length() > 0) {
                sb1.append(delimiter);
            }
            sb1.append(sb2);
            return sb1;
        },
        sb -> prefix + sb.toString() + suffix
    );
}

// Usage
String result = people.stream()
    .collect(joinWithPrefixSuffix(
        Person::getName,
        " | ",
        "Names: ",
        "."
    ));
// Result: "Names: Alice | Bob | Charlie | Dave | Eve."
```

---

## Parallel Streams

Parallel streams allow operations to be executed concurrently, potentially improving performance on multi-core systems.

### When to Use Parallel Streams

Parallel streams are beneficial in the following scenarios:

1. **Large data sets**: When processing millions of elements
2. **CPU-intensive operations**: When each element requires significant computation
3. **Independent operations**: When operations on each element don't depend on other elements
4. **No shared mutable state**: When operations don't modify shared variables

```java
// Creating parallel streams
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// Method 1: From collection
Stream<Integer> parallelStream1 = numbers.parallelStream();

// Method 2: From existing stream
Stream<Integer> parallelStream2 = numbers.stream().parallel();

// Performance comparison example
long start = System.currentTimeMillis();
long sequentialSum = IntStream.range(0, 10_000_000)
    .mapToLong(i -> i)
    .sum();
long sequentialTime = System.currentTimeMillis() - start;

start = System.currentTimeMillis();
long parallelSum = IntStream.range(0, 10_000_000)
    .parallel()
    .mapToLong(i -> i)
    .sum();
long parallelTime = System.currentTimeMillis() - start;

System.out.println("Sequential: " + sequentialTime + "ms");
System.out.println("Parallel: " + parallelTime + "ms");
```

### Performance Considerations

1. **Splitting cost**: The overhead of splitting the data and merging results
2. **Thread coordination**: The cost of managing multiple threads
3. **Data structure**: Some data structures split better than others (ArrayList vs. LinkedList)
4. **Boxing/unboxing**: Primitive streams are more efficient than boxed streams
5. **Operation complexity**: Simple operations may not benefit from parallelization

### Common Pitfalls

1. **Stateful operations**: Operations that depend on state from previous elements
2. **Shared mutable state**: Modifying shared variables can cause race conditions
3. **Non-associative operations**: Operations where order matters (like subtraction)
4. **Limited parallelism**: Too many parallel streams can exhaust thread pool resources

```java
// BAD: Shared mutable state
List<Integer> results = new ArrayList<>();
numbers.parallelStream()
    .map(i -> i * 2)
    .forEach(results::add);  // Race condition!

// GOOD: Use thread-safe collection methods
List<Integer> results = numbers.parallelStream()
    .map(i -> i * 2)
    .collect(Collectors.toList());  // Thread-safe

// BAD: Order-dependent operation
String result = words.parallelStream()
    .reduce("", (a, b) -> a + b);  // Order matters for string concatenation

// GOOD: Use appropriate collector
String result = words.parallelStream()
    .collect(Collectors.joining());  // Designed for parallel execution
```

---

## Stream Best Practices

### Efficiency Guidelines

1. **Use specialized streams** for primitives (IntStream, LongStream, DoubleStream)
2. **Choose the right operations** for your task
3. **Consider the order** of operations (filter before map when possible)
4. **Avoid unnecessary boxing/unboxing**
5. **Use parallel streams judiciously**

```java
// Less efficient
Stream.iterate(0, i -> i + 1)
    .limit(1000)
    .filter(i -> i % 2 == 0)
    .map(i -> i * 2)
    .collect(Collectors.toList());

// More efficient
IntStream.range(0, 1000)
    .filter(i -> i % 2 == 0)
    .map(i -> i * 2)
    .boxed()
    .collect(Collectors.toList());
```

### Debugging Streams

1. **Use peek() for debugging**
2. **Break complex streams into smaller parts**
3. **Extract predicates and functions to named variables**

```java
// Hard to debug
List<String> result = people.stream()
    .filter(p -> p.getAge() > 30)
    .map(Person::getName)
    .filter(name -> name.length() > 4)
    .collect(Collectors.toList());

// Easier to debug
Predicate<Person> isOver30 = p -> p.getAge() > 30;
Function<Person, String> getName = Person::getName;
Predicate<String> isLongName = name -> name.length() > 4;

List<String> result = people.stream()
    .filter(isOver30)
    .peek(p -> System.out.println("After age filter: " + p.getName()))
    .map(getName)
    .peek(name -> System.out.println("After mapping: " + name))
    .filter(isLongName)
    .peek(name -> System.out.println("After name filter: " + name))
    .collect(Collectors.toList());
```

### Common Anti-patterns

1. **Using streams for everything**: Sometimes traditional loops are more readable
2. **Overusing collect()**: Not every stream needs to end with collect()
3. **Ignoring existing methods**: Using custom logic when standard methods exist
4. **Misusing parallel streams**: Using parallel streams for small datasets or I/O-bound operations

```java
// Anti-pattern: Complex logic in lambda
List<Integer> evenSquares = numbers.stream()
    .filter(n -> {
        // Complex multi-line logic here
        boolean isEven = n % 2 == 0;
        System.out.println("Checking " + n + ": " + isEven);
        return isEven;
    })
    .map(n -> n * n)
    .collect(Collectors.toList());

// Better: Extract to method
boolean isEven(int n) {
    System.out.println("Checking " + n);
    return n % 2 == 0;
}

List<Integer> evenSquares = numbers.stream()
    .filter(this::isEven)
    .map(n -> n * n)
    .collect(Collectors.toList());
```

---

## Advanced Stream Concepts

### Specialized Streams

Java provides specialized stream classes for primitive types to avoid boxing/unboxing overhead:

```java
// IntStream
IntStream intStream = IntStream.range(1, 10);  // 1 to 9
int sum = intStream.sum();  // 45

// LongStream
LongStream longStream = LongStream.rangeClosed(1L, 1000000000L);
long count = longStream.count();  // 1000000000

// DoubleStream
DoubleStream doubleStream = DoubleStream.of(1.1, 2.2, 3.3);
double average = doubleStream.average().orElse(0.0);  // 2.2

// Converting between streams
Stream<Integer> boxedStream = IntStream.range(1, 10).boxed();
IntStream unboxedStream = Stream.of(1, 2, 3).mapToInt(Integer::intValue);

// Special operations
IntSummaryStatistics stats = IntStream.range(1, 100)
    .summaryStatistics();
System.out.println("Count: " + stats.getCount());
System.out.println("Sum: " + stats.getSum());
System.out.println("Min: " + stats.getMin());
System.out.println("Max: " + stats.getMax());
System.out.println("Average: " + stats.getAverage());
```

### Optional with Streams

Streams work well with Optional to handle potentially missing values:

```java
// Finding elements that might not exist
Optional<Person> oldest = people.stream()
    .max(Comparator.comparing(Person::getAge));

// Using Optional methods
oldest.ifPresent(p -> System.out.println("Oldest person: " + p.getName()));

String oldestName = oldest
    .map(Person::getName)
    .orElse("No people in the list");

// Stream of Optionals
List<Optional<String>> optionals = Arrays.asList(
    Optional.of("A"),
    Optional.empty(),
    Optional.of("B")
);

// Filter and unwrap non-empty Optionals
List<String> filteredList = optionals.stream()
    .filter(Optional::isPresent)
    .map(Optional::get)
    .collect(Collectors.toList());
// Result: ["A", "B"]

// Using flatMap with Optional
List<String> filteredList2 = optionals.stream()
    .flatMap(opt -> opt.map(Stream::of).orElseGet(Stream::empty))
    .collect(Collectors.toList());
// Result: ["A", "B"]
```

### Spliterator

Spliterator is the mechanism that enables parallel processing in streams:

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// Get a spliterator from a collection
Spliterator<Integer> spliterator = numbers.spliterator();

// Characteristics of a spliterator
int characteristics = spliterator.characteristics();
boolean isSized = spliterator.hasCharacteristics(Spliterator.SIZED);
boolean isOrdered = spliterator.hasCharacteristics(Spliterator.ORDERED);

// Splitting a spliterator for parallel processing
Spliterator<Integer> secondHalf = spliterator.trySplit();

// Process each half
spliterator.forEachRemaining(System.out::println);  // First half
secondHalf.forEachRemaining(System.out::println);   // Second half

// Custom spliterator for specialized data structures
class CustomSpliterator<T> implements Spliterator<T> {
    // Implementation details
}
```

---

## Real-world Examples

### Data Processing Pipelines

```java
class Order {
    private long id;
    private String customer;
    private List<OrderItem> items;
    private LocalDate orderDate;
    private OrderStatus status;
    
    // Constructor, getters, setters
    // ...
    
    public double getTotalAmount() {
        return items.stream()
            .mapToDouble(item -> item.getPrice() * item.getQuantity())
            .sum();
    }
}

enum OrderStatus { NEW, PROCESSING, SHIPPED, DELIVERED, CANCELLED }

class OrderItem {
    private String product;
    private int quantity;
    private double price;
    
    // Constructor, getters, setters
    // ...
}

// Process orders
List<Order> orders = getOrders();  // Assume this method exists

// Get total revenue by customer
Map<String, Double> revenueByCustomer = orders.stream()
    .filter(order -> order.getStatus() != OrderStatus.CANCELLED)
    .collect(Collectors.groupingBy(
        Order::getCustomer,
        Collectors.summingDouble(Order::getTotalAmount)
    ));

// Find top 3 customers by revenue
List<String> topCustomers = revenueByCustomer.entrySet().stream()
    .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
    .limit(3)
    .map(Map.Entry::getKey)
    .collect(Collectors.toList());

// Get monthly sales report
Map<Month, Double> monthlySales = orders.stream()
    .filter(order -> order.getOrderDate().getYear() == Year.now().getValue())
    .collect(Collectors.groupingBy(
        order -> order.getOrderDate().getMonth(),
        Collectors.summingDouble(Order::getTotalAmount)
    ));
```

### File Processing

```java
// Count word frequency in a file
Map<String, Long> wordFrequency;
try (Stream<String> lines = Files.lines(Paths.get("document.txt"))) {
    wordFrequency = lines
        .flatMap(line -> Arrays.stream(line.toLowerCase().split("\\W+")))
        .filter(word -> !word.isEmpty())
        .collect(Collectors.groupingBy(
            Function.identity(),
            Collectors.counting()
        ));
} catch (IOException e) {
    e.printStackTrace();
    wordFrequency = Collections.emptyMap();
}

// Find top 10 most common words
List<Map.Entry<String, Long>> topWords = wordFrequency.entrySet().stream()
    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
    .limit(10)
    .collect(Collectors.toList());

// Process log files
try (Stream<String> logLines = Files.lines(Paths.get("server.log"))) {
    // Extract error logs
    List<String> errorLogs = logLines
        .filter(line -> line.contains("ERROR"))
        .collect(Collectors.toList());
    
    // Count errors by type
    Map<String, Long> errorsByType = errorLogs.stream()
        .map(line -> {
            // Extract error type using regex
            Matcher matcher = Pattern.compile("ERROR: ([A-Z_]+)").matcher(line);
            return matcher.find() ? matcher.group(1) : "UNKNOWN";
        })
        .collect(Collectors.groupingBy(
            Function.identity(),
            Collectors.counting()
        ));
} catch (IOException e) {
    e.printStackTrace();
}
```

### Database Operations

```java
// Assume we have a repository that returns a stream of entities
Stream<Customer> customerStream = customerRepository.streamAll();

// Process customers in batches to avoid loading all into memory
AtomicInteger counter = new AtomicInteger();
List<List<Customer>> batches = customerStream
    .collect(Collectors.groupingBy(c -> counter.getAndIncrement() / 1000))
    .values()
    .stream()
    .collect(Collectors.toList());

// Process each batch
batches.forEach(batch -> {
    // Process batch
    processBatch(batch);
});

// Transform database results
List<CustomerDTO> dtos = customerRepository.findByStatus("ACTIVE")
    .stream()
    .map(customer -> new CustomerDTO(
        customer.getId(),
        customer.getName(),
        customer.getEmail()
    ))
    .collect(Collectors.toList());

// Complex database query with streams
List<Order> highValueOrders = orderRepository.streamAll()
    .filter(order -> order.getStatus() != OrderStatus.CANCELLED)
    .filter(order -> order.getTotalAmount() > 1000.0)
    .sorted(Comparator.comparing(Order::getOrderDate).reversed())
    .limit(100)
    .collect(Collectors.toList());
```

### cheat-sheet
```java
        // Create
        Stream.of(1, 2, 3)
        Arrays.stream(array)
        collection.stream()

        // Transform
        .filter(predicate)
        .map(function)
        .flatMap(function)
        .distinct()
        .sorted()
        .peek(consumer)
        .limit(n)
        .skip(n)

        // Collect
        .collect(toList())
        .collect(toSet())
        .collect(joining(", "))
        .collect(groupingBy(classifier))

        // Reduce
        .reduce(identity, accumulator)
        .count()
        .min(comparator)
        .max(comparator)

        // Find
        .findFirst()
        .findAny()
        .anyMatch(predicate)
        .allMatch(predicate)
        .noneMatch(predicate)

        // Process
        .forEach(consumer)
```