#include "djikstras.h"
#include <godot_cpp/core/class_db.hpp>
#include <vector>
#include <queue>
#include <algorithm>

using namespace godot;

void Dijkstra_Native::_bind_methods() {
    ClassDB::bind_method(D_METHOD("find_heist_path", "source", "target", "V", "adj"), &Dijkstra_Native::find_heist_path);
}

Dijkstra_Native::Dijkstra_Native() {}
Dijkstra_Native::~Dijkstra_Native() {}

Array Dijkstra_Native::find_heist_path(int source, int target, int V, Array adj) {
    // 1. Convert Godot Array to C++ Adjacency List
    std::vector<std::vector<std::pair<int, int>>> cpp_adj(V);
    for (int i = 0; i < V; i++) {
        Array neighbors = adj[i];
        for (int j = 0; j < neighbors.size(); j++) {
            Array edge = neighbors[j]; // [neighbor_index, weight]
            cpp_adj[i].push_back({(int)edge[0], (int)edge[1]});
        }
    }

    // 2. Run the Dijkstra Logic (Your previous code)
    std::vector<int> dist(V, 2147483647); // INT_MAX
    std::vector<int> parent(V, -1);
    std::priority_queue<std::pair<int, int>, std::vector<std::pair<int, int>>, std::greater<std::pair<int, int>>> pq;

    dist[source] = 0;
    pq.push({0, source});

    while (!pq.empty()) {
        int u = pq.top().second;
        pq.pop();
        if (u == target) break;

        for (auto& edge : cpp_adj[u]) {
            int v = edge.first;
            int weight = edge.second;
            if (dist[u] + weight < dist[v]) {
                dist[v] = dist[u] + weight;
                parent[v] = u;
                pq.push({dist[v], v});
            }
        }
    }

    // 3. Reconstruct Path and return as Godot Array
    Array final_path;
    if (dist[target] == 2147483647) return final_path;

    for (int v = target; v != -1; v = parent[v]) {
        final_path.push_front(v);
    }
    return final_path;
}
