#include "pt4.h"
#include <vector>
#include <string>
#include <cstdlib>
#include <numeric>
using namespace std;

class Iterator
{
public:
    virtual void First() = 0;
    virtual void Next() = 0;
    virtual bool IsDone() = 0;
    virtual int CurrentItem() = 0;
    virtual ~Iterator() = default;
};

class Aggregate
{
public:
    virtual Iterator* CreateIterator() = 0;
    virtual ~Aggregate() = default;
};

// ConcreteAggregateA,
// ConcreteAggregateB ?ConcreteAggregateC
class ConcreteAggregateA : public Aggregate
{
public:
    ConcreteAggregateA(int data) : data(data) { }
    Iterator* CreateIterator() override;
    // data
    int data;
    // state
    int divied = 1;
};

class ConcreteAggregateB : public Aggregate
{
public:
    ConcreteAggregateB(string data) : data(data) { }
    Iterator* CreateIterator() override;
    // data
    string data;
    // state
    int index = 0;
};

class ConcreteAggregateC : public Aggregate
{
public:
    ConcreteAggregateC(vector<int> data) : data(data) { }
    Iterator* CreateIterator() override;
    // data
    vector<int> data;
    // state
    int index = 0;
    int divied = 1;
};

// ConcreteIteratorA,
// ConcreteIteratorB ?ConcreteIteratorC
class ConcreteIteratorA : public Iterator
{
public:
    ConcreteIteratorA(ConcreteAggregateA* aggr) : aggr(aggr) { }
    virtual void First() override { aggr->divied = 1; }
    virtual void Next() override { aggr->divied *= 10; }
    virtual bool IsDone() override { return aggr->data && aggr->data / aggr->divied == 0 || !aggr->data && aggr->divied == 10; }
    virtual int CurrentItem() override { return abs(aggr->data / aggr->divied % 10); }
private:
    ConcreteAggregateA* aggr;
};

class ConcreteIteratorB : public Iterator
{
public:
    ConcreteIteratorB(ConcreteAggregateB* aggr) : aggr(aggr) { }
    virtual void First() override { aggr->index = aggr->data.length() - 1; while (aggr->index >= 0 && !isdigit(aggr->data[aggr->index])) aggr->index--; }
    virtual void Next() override { aggr->index--; while (aggr->index >= 0 && !isdigit(aggr->data[aggr->index])) aggr->index--; }
    virtual bool IsDone() override { return aggr->index < 0; }
    virtual int CurrentItem() override { return aggr->data[aggr->index] - '0'; }
private:
    ConcreteAggregateB* aggr;
};

class ConcreteIteratorC : public Iterator
{
public:
    ConcreteIteratorC(ConcreteAggregateC* aggr) : aggr(aggr) { }
    virtual void First() override { aggr->index = aggr->data.size() - 1; aggr->divied = 1; }
    virtual void Next() override;
    virtual bool IsDone() override { return aggr->index < 0; }
    virtual int CurrentItem() override { return abs(aggr->data[aggr->index] / aggr->divied % 10); }
private:
    ConcreteAggregateC* aggr;
};

void ConcreteIteratorC::Next()
{
    aggr->divied *= 10;
    int data = aggr->data[aggr->index];
    int divied = aggr->divied;
    if (data && data / divied == 0 || !data && divied == 10) {
        aggr->index--;
        aggr->divied = 1;
    }
}

Iterator* ConcreteAggregateA::CreateIterator()
{
    return new ConcreteIteratorA(this);
}
Iterator* ConcreteAggregateB::CreateIterator()
{
    return new ConcreteIteratorB(this);
}
Iterator* ConcreteAggregateC::CreateIterator()
{
    return new ConcreteIteratorC(this);
}

void Solve()
{
    Task("OOP3Behav7");

    int n;
    pt >> n;
    char type;
    vector<Aggregate*> aggr(n);
    for (int i = 0; i < n; i++) {
        pt >> type;
        if (type == 'A') {
            int data;
            pt >> data;
            aggr[i] = new ConcreteAggregateA(data);
        }
        else if (type == 'B') {
            string data;
            pt >> data;
            aggr[i] = new ConcreteAggregateB(data);
        }
        else {
            int k, num;
            pt >> k;
            vector<int> data(k);
            for (int i = 0; i < k; i++) {
                pt >> num;
                data[i] = num;
            }
            aggr[i] = new ConcreteAggregateC(data);
        }
    }

    for (auto ait = aggr.rbegin(); ait != aggr.rend(); ait++) {
        vector<int> digits;
        auto it = (*ait)->CreateIterator();
        for (it->First(); !it->IsDone(); it->Next())
            digits.push_back(it->CurrentItem());
        pt << accumulate(digits.begin(), digits.end(), 0);
        for (auto n : digits)
            pt << n;
    }
}
