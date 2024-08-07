#include "pt4.h"
using namespace std;

class BaseClass
{
    int data = 0;
public:
    void IncData(int increment);
    int GetData();
};
void BaseClass::IncData(int increment)
{
    data += increment;
}
int BaseClass::GetData()
{
    return data;
}

class Singleton : public BaseClass
{
    static Singleton* uniqueInstance;
    Singleton() {}
    ~Singleton() {}
public:
    static int instanceCount();
    static Singleton* instance();
    // Complete the implementation of the class
};

Singleton* Singleton::uniqueInstance = nullptr;

int Singleton::instanceCount() 
{
    {
        if (uniqueInstance == nullptr)
            return 0;
        else
            return 1;
    }
}
Singleton* Singleton::instance() 
{
    if (uniqueInstance == nullptr)
        uniqueInstance = new Singleton;
    return uniqueInstance;
}

class Doubleton : public BaseClass
{
    static Doubleton* instances[];
    Doubleton() {}
    ~Doubleton() {}
public:
    static Doubleton* instance1();
    static Doubleton* instance2();
    static int instanceCount();
    // Complete the implementation of the class
};

Doubleton* Doubleton::instances[2];

Doubleton* Doubleton::instance1() 
{
    if (instances[0] == nullptr)
        instances[0] = new Doubleton;
    return instances[0];
}
Doubleton* Doubleton::instance2() 
{
    if (instances[1] == nullptr)
        instances[1] = new Doubleton;
    return instances[1];
}
int Doubleton::instanceCount() 
{
    int ncount = 0;
    for (int i = 0; i < 2; i++) 
	{
        if (instances[i] != nullptr)
            ncount++;
    }
    return ncount;
}

class Tenton : public BaseClass
{
    static Tenton* instances[];
    Tenton() {}
    ~Tenton() {}
public:
    static Tenton* instancen(int n);
    static int instanceCount();
    // Complete the implementation of the class
};

Tenton* Tenton::instances[10];

Tenton* Tenton::instancen(int n) 
{
    if (instances[n] == nullptr)
        instances[n] = new Tenton;
    return instances[n];
}
int Tenton::instanceCount() 
{
    int ncount = 0;
    for (int i = 0; i < 10; i++)
	{
        if (instances[i] != nullptr)
            ncount++;
    }
    return ncount;
}

void Solve()
{
    Task("OOP1Creat6");
    int N;
    pt >> N;
    BaseClass** b = new BaseClass*[N];
    
    for (int i = 0; i < N; i++)
	{
        string str;
        pt >> str;
        switch (str[0]) 
		{
        case 'S':
            b[i] = Singleton::instance();
            break;
        case 'D':
            if(str[1] == '1')
                b[i] = Doubleton::instance1();
            else
                b[i] = Doubleton::instance2();
            break;
        case 'T':
            b[i] = Tenton::instancen(str[1] - '0');
            break;
        }
    }
    
    pt << Singleton::instanceCount() 
	<< Doubleton::instanceCount() 
	<< Tenton::instanceCount();

    int K;
    pt >> K;
    for (int i = 0; i < K; i++)
	{
        int n, number;
        pt >> n >> number;
        b[n]->IncData(number);
    }
    
    for (int i = 0; i < N; i++)
	{
        pt << b[i]->GetData();
    }
    
}
