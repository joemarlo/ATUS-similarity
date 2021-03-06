// create dollar formatter
var formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',

  // These options are needed to round to whole numbers
  minimumFractionDigits: 0,
  maximumFractionDigits: 0,
});

function classifySequence(input_sequence, modal_sequences){
  //https://www.npmjs.com/package/string-similarity
  //bestMatch = stringSimilarity.findBestMatch(input_sequence, modal_sequences).bestMatchIndex

  //https://gist.github.com/andrei-m/982927
  scores = modal_sequences.map(string => getEditDistance(input_sequence, string))
  bestMatch = scores.indexOf(Math.min(...scores));
  cluster = "Cluster " + (bestMatch + 1)
  return cluster
}

// https://stackoverflow.com/questions/14446511/most-efficient-method-to-groupby-on-an-array-of-objects?page=1&tab=votes#tab-top
function groupBy(list, keyGetter) {
    const map = new Map();
    list.forEach((item) => {
         const key = keyGetter(item);
         const collection = map.get(key);
         if (!collection) {
             map.set(key, [item]);
         } else {
             collection.push(item);
         }
    });
    return map;
}

// https://gist.github.com/robotlolita/8208773
// Frees the `[].slice` method to accept `this` as the first actual argument,
// rather than a special argument.
var toArray = Function.call.bind([].slice)

// To make searching efficient (O(1)), we switch the
// list of things to a HashMap, which allows we to
// retrieve an item by its name in constant time.
function indexBy(field, list) {
    return list.reduce(function(result, item) {
        result[item[field]] = item
        return result
    }, {})
}


// Finally, we want something that for every item in
// the input array, enriches the object with the information
// from the other array
function mergeOn(hashmap, field, list) {
    return list.reduce(function(result, item) {
        var key = item[field]
        return key in hashmap?  push(result, extend(hashmap[key], item))
        :      /* otherwise */  result
    }, [])

    function push(xs, x){ xs.push(x); return xs }
}


// This just merges a list of objects
function extend(/* ...objects */) {
    return toArray(arguments).reduce(function(result, source) {
        return Object.keys(source).reduce(function(result, key) {
            result[key] = source[key]
            return result
        }, result)
    }, {})
}
