/**
 * Standard utilities that are included in any solution program.
 */
module util;

public import std.stdio;
public import std.file;
public import std.string;
public import std.algorithm;
public import std.conv;
public import std.path;
public import std.uni;
public import std.array;
public import std.format;

/** 
 * Simple set implementation since the stdlib doesn't really have a good one.
 */
struct Set(T) {
    T[] items;
    this(T[] items) {
        foreach (i; items) {
            if (!this.contains(i)) this.add(i);
        }
    }

    bool contains(T element) {
        return this.items.canFind(element);
    }

    bool add(T element) {
        if (!this.items.canFind(element)) {
            this.items ~= element;
            return true;
        }
        return false;
    }

    bool remove(T element) {
        size_t[] indexes;
        foreach (e, i; this.items) {
            if (e == element) indexes ~= i;
        }
        this.items = this.items.remove(indexes);
        return indexes.length > 0;
    }

    Set!T intersectWith(Set!T other) {
        T[] intersectingItems;
        foreach (e; this.items) {
            if (other.contains(e)) intersectingItems ~= e;
        }
        return Set(intersectingItems);
    }

    Set!T unionWith(Set!T other) {
        Set!T u = Set(this.items);
        foreach (e; other.items) {
            u.add(e);
        }
        return u;
    }
}
