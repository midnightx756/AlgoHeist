#ifndef DIJKSTRAS_H
#define DIJKSTRAS_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>

namespace godot {

    class Dijkstra_Native : public Node {
        GDCLASS(Dijkstra_Native, Node)

    protected:
        static void _bind_methods();

    public:
        Dijkstra_Native();
        ~Dijkstra_Native();

        // The function you will call from GDScript
        Array find_heist_path(int source, int target, int V, Array adj);
    };

}

#endif
