#include <iostream>
#include <stdio.h>

extern "C" double average_of_array(double array[], int length); // assembler functions
extern "C" int character_count(char string[], char character);

int main()
{
    int choice = 0;

    std::cout << "Alicja Bartczak, Edyta Szymanska" << std::endl;
    std::cout << "Choose what you want to do:" << std::endl;
    std::cout << "(1) - calculate the average value of the array," << std::endl;
    std::cout << "(2) - see how many times a given character appears in the string" << std::endl;
    std::cin >> choice;

    switch (choice) {
    case 1:
    {   // limits the scope of variables, case2 doesn't throw an error

        int p = 0;
        float size;

        double* array1 = new double [size];

        std::cout << "Enter the size of the array: [0,257]" << std::endl;
        std::cin >> size;
        int size1 = size;
        float result = size / size1;
        if (result != 1) {
            std::cout << "Size must be a whole number" << std::endl;
            break;
        }
        if (size == -0)
        {
            std::cout << "That's not a number" << std::endl;
            break;
        }
        std::cout << std::endl << "Enter the values of the array elements: " << std::endl;
        for (int i = 0; i < size; i++){
            std::cout << "element " << i + 1 << ": " << std::endl;
            std::cin >> array1[i];
            if (array1[i] == -0)
            {
                std::cout << "Error, that's not a number" << std::endl;
                p = 1;
                break;
            }
            if (p == 1) break;
        }
        if (p == 0)
        {
            double average = average_of_array(array1, size);
            std::cout << "The average of the provided array is: " << average << std::endl;
        }
        delete[] array1;
        break;
    }
    case 2:
    {
        char string[256];
        char character;
        int length;
        for (int i = 0; i < 256; i++)
        {
            string[i] = 0;
        }
        std::cout << std::endl << "Enter the character to search for: " << std::endl;
        scanf("%c", &character);

        std::cout << std::endl << "Enter the string of characters: " << std::endl;
        std::cin.sync();
        std::cin.getline(string, 256);

        int frequency = character_count(string, character);
        std::cout << "The character '" << character << "' appears in the string " << frequency << " times" << std::endl;

        break;
    }
    default:
        std::cout << "Invalid option number provided" << std::endl;
        break;
    }

    return 0;
}
