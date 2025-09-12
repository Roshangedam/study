Term	Type / Interface	Kaam	Use Case Example
Mapper	Function<T,R>	Element ko transform karta hai	map(s -> s.length())
Downstream	Collector	Nested collector	groupingBy(..., counting())
Accumulator	BiConsumer<A,T>	Element ko mutable container me add karta hai	List me element add karna
Supplier	Supplier<A>	Empty container banata hai	() -> new ArrayList<>()
Finisher	Function<A,R>	Container ko final result me badalta hai	Immutable collection banana
Combiner	BinaryOperator<A>	Partial results ko combine karta hai	Parallel streams ke liye
Predicate	Predicate<T>	True/False check karta hai	filter(s -> s.startsWith("a"))
Comparator	Comparator<T>	Do elements compare karta hai	Sorting, min/max collectors
BinaryOperator	BinaryOperator<T>	Do elements ko combine karta hai	reduce(Integer::sum)
Collector	Interface	Stream ko collect karne ke steps define karta hai	Collectors.toList()