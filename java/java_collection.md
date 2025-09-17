# Java Collections Guide

Welcome to the **Java Collections Guide**! This comprehensive document covers the core concepts and classes of the Java Collections Framework, helping you understand how to efficiently manage groups of objects.

## Table of Contents

1. [Introduction to Java Collections](#1-introduction-to-java-collections)
   
   1.1. [What are Collections?](#11-what-are-collections)
   
   1.2. [Collections Framework Hierarchy](#12-collections-framework-hierarchy)
   
   1.3. [Key Interfaces](#13-key-interfaces)

2. [List](#2-list)
   
   2.1. [Key Implementations](#21-key-implementations)
   
   2.2. [Common Methods](#22-common-methods)
   
   2.3. [Examples](#23-examples)

3. [Set](#3-set)
   
   3.1. [Key Implementations](#31-key-implementations)
   
   3.2. [Common Methods](#32-common-methods)
   
   3.3. [Examples](#33-examples)

4. [Map](#4-map)
   
   4.1. [Key Implementations](#41-key-implementations)
   
   4.2. [Common Methods](#42-common-methods)
   
   4.3. [Examples](#43-examples)
   
    4.3.1. [Basic Map Usage](#431-basic-map-usage)
        
    4.3.2. [Traversing Map Using `entrySet()`](#432-traversing-map-using-entryset)
        
    4.3.3. [Sorting a Map by Keys (Using `TreeMap`)](#433-sorting-a-map-by-keys-using-treemap)
        
    4.3.4. [Sorting a Map by Values Using Streams](#434-sorting-a-map-by-values-using-streams)
        
    4.3.5. [Using Stream API to Filter and Collect](#435-using-stream-api-to-filter-and-collect)
        
    4.3.6. [Complex Map: `Map<Object, List<Object>>`](#436-complex-map-mapobject-listobject)
        
    4.3.7. [Sorting Internal Lists in Reverse Order](#437-sorting-internal-lists-in-reverse-order)

5. [Queue](#5-queue)
   
   5.1. [Key Implementations](#51-key-implementations)
   
   5.2. [Common Methods](#52-common-methods)
   
   5.3. [Examples](#53-examples)

6. [Deque](#6-deque)
   
   6.1. [Key Implementations](#61-key-implementations)
   
   6.2. [Common Methods](#62-common-methods)
   
   6.3. [Examples](#63-examples)

7. [Sorting and Searching](#7-sorting-and-searching)
   
   7.1. [Collections.sort()](#71-collectionssort)
   
   7.2. [Custom Comparators](#72-custom-comparators)
   
   7.3. [Binary Search](#73-binary-search)
   
   7.4. [Examples](#74-examples)

8. [Concurrency in Collections](#8-concurrency-in-collections)
   
   8.1. [Synchronized Collections](#81-synchronized-collections)
   
   8.2. [Concurrent Collections](#82-concurrent-collections)
   
   8.3. [Examples](#83-examples)

9. [Performance Considerations](#9-performance-considerations)
   
   9.1. [Time Complexity](#91-time-complexity)
   
   9.2. [Memory Usage](#92-memory-usage)
   
   9.3. [Best Practices](#93-best-practices)

---

## 1. Introduction to Java Collections

### 1.1. What are Collections?

The Java Collections Framework is a unified architecture for representing and manipulating collections of objects. It provides a set of interfaces and classes to store, retrieve, manipulate, and communicate aggregate data efficiently.

**Benefits of Collections Framework:**
- Reduces programming effort by providing data structures and algorithms
- Increases performance through high-performance implementations
- Provides interoperability between unrelated APIs
- Reduces effort in learning APIs
- Reduces effort in designing and implementing APIs

### 1.2. Collections Framework Hierarchy

```
Collection (Interface)
├── List (Interface)
│   ├── ArrayList
│   ├── LinkedList
│   └── Vector
├── Set (Interface)
│   ├── HashSet
│   ├── LinkedHashSet
│   └── TreeSet
└── Queue (Interface)
    ├── PriorityQueue
    ├── LinkedList
    └── Deque (Interface)
        ├── ArrayDeque
        └── LinkedList

Map (Interface) - Separate hierarchy
├── HashMap
├── LinkedHashMap
├── TreeMap
└── Hashtable
```

### 1.3. Key Interfaces

- **Collection**: The root interface for all collections except Map
- **List**: Ordered collection that allows duplicates
- **Set**: Collection that doesn't allow duplicates
- **Queue**: Collection designed for processing elements in a specific order
- **Map**: Key-value pair collection (not part of Collection hierarchy)

---

## 2. List

The `List` interface represents an ordered collection (sequence) that allows duplicate elements. Lists provide precise control over where each element is inserted and accessed by index.

### 2.1. Key Implementations

- **ArrayList**: Resizable array implementation, fast random access, slower insertion/deletion in middle
- **LinkedList**: Doubly-linked list implementation, fast insertion/deletion, slower random access
- **Vector**: Legacy synchronized version of ArrayList (generally avoid)

### 2.2. Common Methods

- `add(E element)` — Appends element to the end
- `add(int index, E element)` — Inserts element at specified position
- `get(int index)` — Returns element at specified position
- `set(int index, E element)` — Replaces element at specified position
- `remove(int index)` — Removes element at specified position
- `size()` — Returns number of elements
- `indexOf(Object o)` — Returns index of first occurrence
- `contains(Object o)` — Checks if list contains element

### 2.3. Examples

#### Basic ArrayList Operations
```java
List<String> list = new ArrayList<>();
list.add("apple");
list.add("banana");
list.add("cherry");

System.out.println(list.get(1)); // banana
list.set(1, "blueberry");
System.out.println(list); // [apple, blueberry, cherry]
```

#### LinkedList for Frequent Insertions
```java
List<Integer> linkedList = new LinkedList<>();
linkedList.add(1);
linkedList.add(0, 0); // Insert at beginning - O(1)
linkedList.add(2);
System.out.println(linkedList); // [0, 1, 2]
```

#### List Iteration and Processing
```java
List<String> fruits = Arrays.asList("apple", "banana", "cherry");

// Traditional for-each loop
for (String fruit : fruits) {
    System.out.println(fruit.toUpperCase());
}

// Using streams
fruits.stream()
      .filter(f -> f.startsWith("a"))
      .forEach(System.out::println);
```

---

## 3. Set

The `Set` interface represents a collection that contains no duplicate elements. It models the mathematical set abstraction.

### 3.1. Key Implementations

- **HashSet**: Hash table implementation, no ordering guarantees, fastest performance
- **LinkedHashSet**: Hash table with linked list, maintains insertion order
- **TreeSet**: Red-black tree implementation, sorted order, implements NavigableSet

### 3.2. Common Methods

- `add(E element)` — Adds element if not already present
- `remove(Object o)` — Removes specified element
- `contains(Object o)` — Checks if set contains element
- `size()` — Returns number of elements
- `isEmpty()` — Checks if set is empty
- `clear()` — Removes all elements

### 3.3. Examples

#### Basic HashSet Operations
```java
Set<String> set = new HashSet<>();
set.add("apple");
set.add("banana");
set.add("apple"); // Duplicate - won't be added

System.out.println(set.size()); // 2
System.out.println(set.contains("apple")); // true
```

#### TreeSet for Sorted Unique Elements
```java
Set<Integer> treeSet = new TreeSet<>();
treeSet.add(5);
treeSet.add(1);
treeSet.add(3);
treeSet.add(1); // Duplicate - won't be added

System.out.println(treeSet); // [1, 3, 5] - sorted order
```

#### Set Operations
```java
Set<String> set1 = new HashSet<>(Arrays.asList("a", "b", "c"));
Set<String> set2 = new HashSet<>(Arrays.asList("b", "c", "d"));

// Union
Set<String> union = new HashSet<>(set1);
union.addAll(set2);
System.out.println("Union: " + union); // [a, b, c, d]

// Intersection
Set<String> intersection = new HashSet<>(set1);
intersection.retainAll(set2);
System.out.println("Intersection: " + intersection); // [b, c]
```

---

## 4. Map

The `Map` interface represents a collection that maps keys to values. It does not allow duplicate keys and each key can map to at most one value.

### 4.1. Key Implementations

- **HashMap**: Hash table implementation, unordered, allows `null` keys and values, fast access
- **LinkedHashMap**: Hash table with linked list, maintains insertion order
- **TreeMap**: Red-black tree implementation, sorted order according to natural ordering or comparator
- **Hashtable**: Legacy synchronized version (generally avoid)

### 4.2. Common Methods

- `put(K key, V value)` — Adds a key-value pair
- `get(Object key)` — Retrieves the value associated with the key
- `remove(Object key)` — Removes the key and its value
- `containsKey(Object key)` — Checks if a key exists
- `containsValue(Object value)` — Checks if a value exists
- `keySet()` — Returns a set of all keys
- `values()` — Returns a collection of all values
- `entrySet()` — Returns a set of key-value pairs
- `putIfAbsent(K key, V value)` — Adds if key doesn't exist

### 4.3. Examples

#### 4.3.1. Basic Map Usage

```java
Map<String, Integer> map = new HashMap<>();
map.put("apple", 3);
map.put("banana", 2);
map.put("cherry", 5);

int count = map.get("apple");  // 3
map.putIfAbsent("date", 1);   // Add only if key doesn't exist
```

#### 4.3.2. Traversing Map Using `entrySet()`

```java
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    System.out.println("Key: " + entry.getKey() + ", Value: " + entry.getValue());
}

// Using lambda
map.forEach((key, value) -> 
    System.out.println("Key: " + key + ", Value: " + value));
```

#### 4.3.3. Sorting a Map by Keys (Using `TreeMap`)

```java
Map<String, Integer> hashMap = new HashMap<>();
hashMap.put("orange", 5);
hashMap.put("apple", 3);
hashMap.put("banana", 2);

Map<String, Integer> treeMap = new TreeMap<>(hashMap);
treeMap.forEach((k, v) -> System.out.println(k + " = " + v));
// Output: apple = 3, banana = 2, orange = 5
```

#### 4.3.4. Sorting a Map by Values Using Streams

```java
Map<String, Integer> map = new HashMap<>();
map.put("orange", 5);
map.put("apple", 3);
map.put("banana", 2);

map.entrySet()
   .stream()
   .sorted(Map.Entry.comparingByValue())
   .forEach(entry -> System.out.println(entry.getKey() + " = " + entry.getValue()));
// Output: banana = 2, apple = 3, orange = 5
```

#### 4.3.5. Using Stream API to Filter and Collect

```java
Map<String, Integer> map = new HashMap<>();
map.put("orange", 5);
map.put("apple", 3);
map.put("banana", 2);

Map<String, Integer> filteredMap = map.entrySet()
    .stream()
    .filter(entry -> entry.getValue() > 2)
    .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

filteredMap.forEach((k, v) -> System.out.println(k + " = " + v));
// Output: orange = 5, apple = 3
```

#### 4.3.6. Complex Map: `Map<Object, List<Object>>`

```java
Map<String, List<Integer>> complexMap = new HashMap<>();

complexMap.put("group1", Arrays.asList(5, 3, 8));
complexMap.put("group2", Arrays.asList(1, 9, 2));

for (Map.Entry<String, List<Integer>> entry : complexMap.entrySet()) {
    List<Integer> sortedList = entry.getValue()
                                   .stream()
                                   .sorted()
                                   .collect(Collectors.toList());

    System.out.println("Key: " + entry.getKey() + ", Sorted List: " + sortedList);
}
```

#### 4.3.7. Sorting Internal Lists in Reverse Order

```java
for (Map.Entry<String, List<Integer>> entry : complexMap.entrySet()) {
    List<Integer> sortedListDesc = entry.getValue()
                                        .stream()
                                        .sorted(Comparator.reverseOrder())
                                        .collect(Collectors.toList());

    System.out.println("Key: " + entry.getKey() + ", Desc Sorted List: " + sortedListDesc);
}
```

---

## 5. Queue

The `Queue` interface represents a collection designed for holding elements before processing. Queues typically order elements in FIFO (first-in-first-out) manner.

### 5.1. Key Implementations

- **LinkedList**: Implements Queue interface, FIFO ordering
- **PriorityQueue**: Priority heap implementation, elements ordered by priority
- **ArrayDeque**: Resizable array implementation of Deque interface

### 5.2. Common Methods

- `offer(E e)` — Inserts element into queue (preferred over add)
- `poll()` — Retrieves and removes head, returns null if empty
- `peek()` — Retrieves but doesn't remove head, returns null if empty
- `add(E e)` — Inserts element (throws exception on failure)
- `remove()` — Retrieves and removes head (throws exception if empty)
- `element()` — Retrieves but doesn't remove head (throws exception if empty)

### 5.3. Examples

#### Basic Queue Operations
```java
Queue<String> queue = new LinkedList<>();
queue.offer("first");
queue.offer("second");
queue.offer("third");

System.out.println(queue.poll()); // "first" - FIFO
System.out.println(queue.peek()); // "second" - doesn't remove
System.out.println(queue.poll()); // "second"
```

#### PriorityQueue Example
```java
Queue<Integer> priorityQueue = new PriorityQueue<>();
priorityQueue.offer(30);
priorityQueue.offer(10);
priorityQueue.offer(20);

while (!priorityQueue.isEmpty()) {
    System.out.println(priorityQueue.poll()); // 10, 20, 30
}
```

#### Custom Priority Queue
```java
Queue<String> customQueue = new PriorityQueue<>(
    (a, b) -> Integer.compare(a.length(), b.length())
);
customQueue.offer("apple");
customQueue.offer("hi");
customQueue.offer("banana");

while (!customQueue.isEmpty()) {
    System.out.println(customQueue.poll()); // "hi", "apple", "banana"
}
```

---

## 6. Deque

The `Deque` (Double Ended Queue) interface represents a linear collection that supports element insertion and removal at both ends.

### 6.1. Key Implementations

- **ArrayDeque**: Resizable array implementation, recommended for stack and queue operations
- **LinkedList**: Doubly-linked list implementation

### 6.2. Common Methods

**First Element (Head) Operations:**
- `addFirst(E e)` / `offerFirst(E e)` — Insert at beginning
- `removeFirst()` / `pollFirst()` — Remove from beginning
- `getFirst()` / `peekFirst()` — Examine first element

**Last Element (Tail) Operations:**
- `addLast(E e)` / `offerLast(E e)` — Insert at end
- `removeLast()` / `pollLast()` — Remove from end  
- `getLast()` / `peekLast()` — Examine last element

**Stack Operations:**
- `push(E e)` — Equivalent to addFirst
- `pop()` — Equivalent to removeFirst

### 6.3. Examples

#### Basic Deque Operations
```java
Deque<String> deque = new ArrayDeque<>();
deque.addFirst("middle");
deque.addFirst("first");
deque.addLast("last");

System.out.println(deque); // [first, middle, last]
System.out.println(deque.removeFirst()); // "first"
System.out.println(deque.removeLast());  // "last"
```

#### Using Deque as Stack
```java
Deque<Integer> stack = new ArrayDeque<>();
stack.push(1);
stack.push(2);
stack.push(3);

while (!stack.isEmpty()) {
    System.out.println(stack.pop()); // 3, 2, 1 - LIFO
}
```

#### Using Deque as Queue
```java
Deque<String> queue = new ArrayDeque<>();
queue.offerLast("first");
queue.offerLast("second");
queue.offerLast("third");

while (!queue.isEmpty()) {
    System.out.println(queue.pollFirst()); // first, second, third - FIFO
}
```

---

## 7. Sorting and Searching

Java provides several utilities for sorting and searching collections through the `Collections` class.

### 7.1. Collections.sort()

```java
List<String> list = new ArrayList<>(Arrays.asList("banana", "apple", "cherry"));
Collections.sort(list);
System.out.println(list); // [apple, banana, cherry]

// Reverse sort
Collections.sort(list, Collections.reverseOrder());
System.out.println(list); // [cherry, banana, apple]
```

### 7.2. Custom Comparators

```java
// Custom class
class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    @Override
    public String toString() {
        return name + "(" + age + ")";
    }
}

List<Person> people = Arrays.asList(
    new Person("Alice", 30),
    new Person("Bob", 25),
    new Person("Charlie", 35)
);

// Sort by age
Collections.sort(people, Comparator.comparingInt(p -> p.age));
System.out.println(people); // [Bob(25), Alice(30), Charlie(35)]

// Sort by name
Collections.sort(people, Comparator.comparing(p -> p.name));
System.out.println(people); // [Alice(30), Bob(25), Charlie(35)]
```

### 7.3. Binary Search

```java
List<Integer> list = Arrays.asList(1, 3, 5, 7, 9);
Collections.sort(list); // Must be sorted first

int index = Collections.binarySearch(list, 5);
System.out.println("Index of 5: " + index); // 2

int notFound = Collections.binarySearch(list, 6);
System.out.println("Index of 6: " + notFound); // negative value
```

### 7.4. Examples

#### Sorting with Multiple Criteria
```java
List<Person> people = Arrays.asList(
    new Person("Alice", 30),
    new Person("Bob", 25),
    new Person("Alice", 25)
);

// Sort by name, then by age
Comparator<Person> comparator = Comparator
    .comparing((Person p) -> p.name)
    .thenComparingInt(p -> p.age);

Collections.sort(people, comparator);
System.out.println(people); // [Alice(25), Alice(30), Bob(25)]
```

#### Stream Sorting
```java
List<String> words = Arrays.asList("apple", "pie", "banana", "a");

List<String> sortedByLength = words.stream()
    .sorted(Comparator.comparing(String::length))
    .collect(Collectors.toList());
System.out.println(sortedByLength); // [a, pie, apple, banana]
```

---

## 8. Concurrency in Collections

Java provides thread-safe collection implementations for concurrent programming.

### 8.1. Synchronized Collections

```java
// Creating synchronized collections
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());

// Manual synchronization needed for iteration
synchronized(syncList) {
    for (String item : syncList) {
        System.out.println(item);
    }
}
```

### 8.2. Concurrent Collections

- **ConcurrentHashMap**: Thread-safe HashMap alternative
- **CopyOnWriteArrayList**: Thread-safe ArrayList for read-heavy operations
- **ConcurrentLinkedQueue**: Thread-safe queue implementation
- **BlockingQueue**: Queue with blocking operations

### 8.3. Examples

#### ConcurrentHashMap Usage
```java
import java.util.concurrent.ConcurrentHashMap;

Map<String, Integer> concurrentMap = new ConcurrentHashMap<>();
concurrentMap.put("key1", 1);
concurrentMap.put("key2", 2);

// Thread-safe operations
concurrentMap.compute("key1", (key, val) -> val == null ? 1 : val + 1);
concurrentMap.putIfAbsent("key3", 3);
```

#### BlockingQueue Example
```java
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

BlockingQueue<String> queue = new LinkedBlockingQueue<>();

// Producer thread
new Thread(() -> {
    try {
        queue.put("item1");
        queue.put("item2");
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
}).start();

// Consumer thread
new Thread(() -> {
    try {
        String item = queue.take(); // Blocks until item available
        System.out.println("Consumed: " + item);
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
}).start();
```

---

## 9. Performance Considerations

### 9.1. Time Complexity

#### ArrayList vs LinkedList
| Operation | ArrayList | LinkedList |
|-----------|-----------|------------|
| get(index) | O(1) | O(n) |
| add(element) | O(1) amortized | O(1) |
| add(index, element) | O(n) | O(n) |
| remove(index) | O(n) | O(n) |

#### Set Implementations
| Operation | HashSet | TreeSet |
|-----------|---------|---------|
| add | O(1) | O(log n) |
| contains | O(1) | O(log n) |
| remove | O(1) | O(log n) |

#### Map Implementations
| Operation | HashMap | TreeMap |
|-----------|---------|---------|
| get | O(1) | O(log n) |
| put | O(1) | O(log n) |
| remove | O(1) | O(log n) |

### 9.2. Memory Usage

- **ArrayList**: Uses array internally, memory efficient for random access
- **LinkedList**: Each element has overhead for node references
- **HashMap**: Additional memory for hash table structure
- **TreeMap**: Additional memory for tree structure

### 9.3. Best Practices

#### Choose the Right Collection
```java
// For frequent random access
List<String> list = new ArrayList<>();

// For frequent insertions/deletions at beginning
List<String> list = new LinkedList<>();

// For unique elements with fast lookup
Set<String> set = new HashSet<>();

// For unique elements in sorted order
Set<String> set = new TreeSet<>();

// For key-value pairs with fast lookup
Map<String, String> map = new HashMap<>();

// For key-value pairs in sorted order
Map<String, String> map = new TreeMap<>();
```

#### Capacity Optimization
```java
// Pre-size collections when size is known
List<String> list = new ArrayList<>(1000);
Map<String, String> map = new HashMap<>(1000);
Set<String> set = new HashSet<>(1000);
```

#### Avoid Auto-boxing in Performance-Critical Code
```java
// Instead of List<Integer>
List<Integer> intList = new ArrayList<>();

// Consider using primitive collections libraries like:
// Eclipse Collections, Trove, or Fastutil for better performance
```

#### Use Stream API Judiciously
```java
// Good for readability and complex operations
List<String> filtered = list.stream()
    .filter(s -> s.length() > 5)
    .collect(Collectors.toList());

// But traditional loops may be faster for simple operations
List<String> filtered = new ArrayList<>();
for (String s : list) {
    if (s.length() > 5) {
        filtered.add(s);
    }
}
```

---

This comprehensive guide covers the essential aspects of Java Collections Framework. Remember to choose the appropriate collection based on your specific use case, considering factors like performance requirements, thread safety, and memory constraints.