#include <stdio.h>
#include <limits.h>

#define V 5   // number of vertices

// Function to find vertex with minimum distance
int minDistance(int dist[], int visited[]) {
    int min = INT_MAX, min_index;

    for (int v = 0; v < V; v++) {
        if (visited[v] == 0 && dist[v] <= min) {
            min = dist[v];
            min_index = v;
        }
    }
    return min_index;
}

// Dijkstra function
void dijkstra(int graph[V][V], int src) {
    int dist[V];      // shortest distances
    int visited[V];   // visited nodes

    // Initialize
    for (int i = 0; i < V; i++) {
        dist[i] = INT_MAX;
        visited[i] = 0;
    }

    dist[src] = 0;

    // Main loop
    for (int count = 0; count < V - 1; count++) {
        int u = minDistance(dist, visited);
        visited[u] = 1;

        for (int v = 0; v < V; v++) {
            if (!visited[v] && graph[u][v] &&
                dist[u] != INT_MAX &&
                dist[u] + graph[u][v] < dist[v]) {

                dist[v] = dist[u] + graph[u][v];
            }
        }
    }

    // Output
    printf("Node \t Min Risk from Source\n");
    for (int i = 0; i < V; i++) {
        printf("%d \t %d\n", i, dist[i]);
    }
}

int main() {
    // Graph as risk matrix (0 = no edge)
    int graph[V][V] = {
        {0, 4, 0, 0, 8},
        {4, 0, 2, 5, 0},
        {0, 2, 0, 1, 0},
        {0, 5, 1, 0, 3},
        {8, 0, 0, 3, 0}
    };

    dijkstra(graph, 0); // start from node 0
    return 0;
}
