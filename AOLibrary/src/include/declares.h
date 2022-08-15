#pragma once

#include <Windows.h>
#include <stdint.h>

#define WIN32_LEAN_AND_MEAN // Excluir material rara vez utilizado de encabezados de Windows
#define VC_EXTRALEAN        // Excluir material rara vez utilizado de encabezados de Windows (de MSVC)

#define EXPORT __declspec(dllexport)

extern "C" {
    void EXPORT CALLBACK CallHandle(DWORD address, int16_t userindex);
}
