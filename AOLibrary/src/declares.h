#pragma once

#include <Windows.h>
#include <stdint.h>

#define WIN32_LEAN_AND_MEAN // Excluir material rara vez utilizado de encabezados de Windows
#define VC_EXTRALEAN        // Excluir material rara vez utilizado de encabezados de Windows (de MSVC)

#ifdef _MSC_VER
    // Creamos un alias con el nombre de la funcion sin decorar
    #define UNDECORATE comment(linker, "/EXPORT:" __FUNCTION__ "=" __FUNCDNAME__)
#endif

#define EXPORT __declspec(dllexport)
