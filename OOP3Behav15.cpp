#include "pt4.h"
using namespace std;

class Visitor;

class Element
{
public:
    virtual void Accept(Visitor* v) = 0;
};

class ConcreteElementA : public Element
{
    // Add required fields
    int data;
public:
    void Accept(Visitor* v) override;
    // Add required methods
    ConcreteElementA(int data) : data(data) {}
    int GetData() { return data; }
    void SetData(int newData) { data = newData; }
};

class ConcreteElementB : public Element
{
    string data;// Add required fields
public:
    void Accept(Visitor* v) override;
    ConcreteElementB(string data) : data(data) {}
    // Add required methods
    string GetData() { return data; }
    void SetData(string newData) { data = newData; }
};

class ConcreteElementC : public Element
{
    // Add required fields
    double data;
public:
    void Accept(Visitor* v)  override;
    ConcreteElementC(double data) : data(data) {}
    // Add required methods
    double GetData() { return data; }
    void SetData(double newData) { data = newData; }
};

class ObjectStructure
{
    vector<Element*> struc;
public:
    ObjectStructure(vector<Element*>& struc) : struc(struc) {}
    void Accept(Visitor* v);
};

void ObjectStructure::Accept(Visitor* v)
{
    for (auto e : struc)
        e->Accept(v);
}

class Visitor
{
public:
    virtual void VisitConcreteElementA(ConcreteElementA* e) = 0;
    virtual void VisitConcreteElementB(ConcreteElementB* e) = 0;
    virtual void VisitConcreteElementC(ConcreteElementC* e) = 0;
};

void ConcreteElementA::Accept(Visitor* v)
{
    // Implement the method
    v->VisitConcreteElementA(this);
}
void ConcreteElementB::Accept(Visitor* v)
{
    // Implement the method
    v->VisitConcreteElementB(this);
}
void ConcreteElementC::Accept(Visitor* v)
{
    // Implement the method
    v->VisitConcreteElementC(this);
}

// Implement the ConcreteVisitor1, ConcreteVisitor2
//   and ConcreteVisitor3 descendant classes
class ConcreteVisitor1 :public Visitor
{
public:
    void VisitConcreteElementA(ConcreteElementA* e) override
    {
        pt << e->GetData();
    }
    void VisitConcreteElementB(ConcreteElementB* e) override
    {
        pt << e->GetData();
    }
    void VisitConcreteElementC(ConcreteElementC* e) override
    {
        pt << e->GetData();
    }
};
class ConcreteVisitor2 :public Visitor
{
public:
    void VisitConcreteElementA(ConcreteElementA* e) override
    {
        e->SetData(0-e->GetData());
    }
    void VisitConcreteElementB(ConcreteElementB* e) override
    {
        string s = e->GetData();
        reverse(s.begin(), s.end());
        e->SetData(s);
    }
    void VisitConcreteElementC(ConcreteElementC* e) override
    {
        e->SetData(1/ e->GetData());
    }
};
class ConcreteVisitor3 :public Visitor
{
    int resultA;
    string resultB;
    double resultC;
public:
    ConcreteVisitor3():resultA(0), resultB(""), resultC(1){}
    void VisitConcreteElementA(ConcreteElementA* e) override
    { 
        resultA = resultA + (e->GetData()); 
    }
    void VisitConcreteElementB(ConcreteElementB* e) override
    {
        resultB = resultB + (e->GetData()); 
    }
    void VisitConcreteElementC(ConcreteElementC* e) override
    {
        resultC = resultC * (e->GetData());
    }
    int GetResultA()
    {
        return resultA;
    }
    string GetResultB()
    {
        return resultB;
    }
    double GetResultC()
    {
        return resultC;
    }
};
void Solve()
{
    Task("OOP3Behav15");
    int N;
    pt >> N;
    vector<Element*> V;
    for (int i = 0; i < N; i++)
    {
        char c;
        pt >> c;
        if (c == 'A')
        {
            int n; pt >> n;
            ConcreteElementA* a = new ConcreteElementA(n);
            V.push_back(a);
        }
        else if (c == 'B')
        {
            string s; pt >> s;
            ConcreteElementB* b = new ConcreteElementB(s);
            V.push_back(b);
        }
        else
        {
            double a; pt >> a;
            ConcreteElementC* c = new ConcreteElementC(a);
            V.push_back(c);
        }
    }
    ObjectStructure* struc=new ObjectStructure(V);
    ConcreteVisitor1* v1 = new ConcreteVisitor1();
    ConcreteVisitor2* v2 = new ConcreteVisitor2();
    ConcreteVisitor3* v3 = new ConcreteVisitor3();
    struc->Accept(v1);
    struc->Accept(v2);
    struc->Accept(v1);
    struc->Accept(v3);
    pt << v3->GetResultA();
    pt << v3->GetResultB();
    pt << v3->GetResultC();
    
}
