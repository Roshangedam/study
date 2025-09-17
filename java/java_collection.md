Absolutely! Here's your updated README with a **numbered Table of Contents** including **proper sub-indexing** for clear navigation and hierarchy, making it easy to see which topic and subtopic the user is reading.

---

# Java Collections Guide

Welcome to the **Java Collections Guide**! This document covers the core concepts and classes of the Java Collections Framework, helping you understand how to efficiently manage groups of objects.

## Table of Contents

1. [Introduction to Java Collections](#1-introduction-to-java-collections)
2. [List](#2-list)
3. [Set](#3-set)
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
6. [Deque](#6-deque)
7. [Sorting and Searching](#7-sorting-and-searching)
8. [Concurrency in Collections](#8-concurrency-in-collections)
9. [Performance Considerations](#9-performance-considerations)

---

## 1. Introduction to Java Collections

*To be added...*

---

## 2. List

*To be added...*

---

## 3. Set

*To be added...*

---

## 4. Map

The `Map` interface represents a collection that maps keys to values. It does not allow duplicate keys and each key can map to at most one value.

### 4.1. Key Implementations

* **HashMap** — Unordered, allows `null` keys and values, fast access.
* **LinkedHashMap** — Maintains insertion order.
* **TreeMap** — Sorted order according to natural ordering or comparator.
* **Hashtable** — Legacy synchronized version (generally avoid).

### 4.2. Common Methods

* `put(K key, V value)` — Adds a key-value pair.
* `get(Object key)` — Retrieves the value associated with the key.
* `remove(Object key)` — Removes the key and its value.
* `containsKey(Object key)` — Checks if a key exists.
* `keySet()` — Returns a set of all keys.
* `values()` — Returns a collection of all values.
* `entrySet()` — Returns a set of key-value pairs.

### 4.3. Examples

#### 4.3.1. Basic Map Usage

```java
Map<String, Integer> map = new HashMap<>();
map.put("apple", 3);
map.put("banana", 2);
int count = map.get("apple");  // 3
```

#### 4.3.2. Traversing Map Using `entrySet()`

```java
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    System.out.println("Key: " + entry.getKey() + ", Value: " + entry.getValue());
}
```

#### 4.3.3. Sorting a Map by Keys (Using `TreeMap`)

```java
Map<String, Integer> hashMap = new HashMap<>();
hashMap.put("orange", 5);
hashMap.put("apple", 3);
hashMap.put("banana", 2);

Map<String, Integer> treeMap = new TreeMap<>(hashMap);
treeMap.forEach((k, v) -> System.out.println(k + " = " + v));
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

*To be added...*

---

## 6. Deque

*To be added...*

---

## 7. Sorting and Searching

*To be added...*

---

## 8. Concurrency in Collections

*To be added...*

---

## 9. Performance Considerations

*To be added...*

---



Got it! You want a **clean, indented, folder-tree style Table of Contents** where subtopics are listed neatly below their parents, each on a new line, visually showing hierarchy clearly.

Here’s the Table of Contents updated with that style, plus anchors to jump directly:

---

# Java Collections Guide

Welcome to the **Java Collections Guide**! This document covers the core concepts and classes of the Java Collections Framework, helping you understand how to efficiently manage groups of objects.

## Table of Contents

1. [Introduction to Java Collections](#1-introduction-to-java-collections)
2. [List](#2-list)
3. [Set](#3-set)
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
     4.4. [Entry Set](#44-entry-set)
5. [Queue](#5-queue)
6. [Deque](#6-deque)
7. [Sorting and Searching](#7-sorting-and-searching)
8. [Concurrency in Collections](#8-concurrency-in-collections)
9. [Performance Considerations](#9-performance-considerations)

---

**If you want, I can also provide the full document with this layout applied everywhere!** Would you like me to?
