#include "pt4.h"
using namespace std;

class State
{
public:
    virtual void InsertCoin() = 0;
    virtual void GetBall() = 0;
    virtual void ReturnCoin() = 0;
    virtual void AddBall() = 0;
};

class BallMachine;

// Implement the ReadyState, HasPayedState
//   and NoBallState descendant classes

class ReadyState : public State
{
	BallMachine* BallMachine;
public:
	virtual void InsertCoin();
	virtual void GetBall();
    virtual void ReturnCoin();
    virtual void AddBall();	
};

void ReadyState::InsertCoin()
{
	pt << "Coin is inserted";
	BallMachine->
	
}

class HasPayedState : public State
{
	BallMachine* BallMachine;
public:
	virtual void InsertCoin();
	virtual void GetBall();
    virtual void ReturnCoin();
    virtual void AddBall();		
};

class NoBallState : public State
{
	BallMachine* BallMachine;
public:
	virtual void InsertCoin();
	virtual void GetBall();
    virtual void ReturnCoin();
    virtual void AddBall();		
};



// Implement the BallMachine class

class BallMachine
{
	int ballCount;
	State* ready;
	State* hasPayed;
	State* noBall;
	State* currentState;
public:
    BallMachine();
    virtual void InsertCoin();
	virtual void GetBall();
    virtual void ReturnCoin();
    virtual void AddBall();	
	virtual void DecreaseBallCount();
	void SetState(new State);	
};

void Solve()
{
    Task("OOP3Behav11");

}
