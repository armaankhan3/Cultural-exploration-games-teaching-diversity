// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CulturalExploration {
    struct Player {
        string name;
        uint256 points;
    }

    struct Quiz {
        string question;
        string correctAnswer;
        uint256 points;
    }

    mapping(address => Player) public players;
    mapping(uint256 => Quiz) public quizzes;

    uint256 public quizCount;
    address public owner;

    event NewPlayer(address indexed playerAddress, string name);
    event PointsEarned(address indexed playerAddress, uint256 points);
    event QuizCreated(uint256 quizId, string question, uint256 points);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerPlayer(string memory _name) public {
        require(bytes(players[msg.sender].name).length == 0, "Player already registered.");
        players[msg.sender] = Player(_name, 0);
        emit NewPlayer(msg.sender, _name);
    }

    function createQuiz(string memory _question, string memory _correctAnswer, uint256 _points) public onlyOwner {
        quizzes[quizCount] = Quiz(_question, _correctAnswer, _points);
        emit QuizCreated(quizCount, _question, _points);
        quizCount++;
    }

    function answerQuiz(uint256 _quizId, string memory _answer) public {
        require(bytes(players[msg.sender].name).length > 0, "Player not registered.");
        require(_quizId < quizCount, "Invalid quiz ID.");

        Quiz memory quiz = quizzes[_quizId];
        if (keccak256(abi.encodePacked(quiz.correctAnswer)) == keccak256(abi.encodePacked(_answer))) {
            players[msg.sender].points += quiz.points;
            emit PointsEarned(msg.sender, quiz.points);
        }
    }

    function getPlayer(address _player) public view returns (string memory, uint256) {
        require(bytes(players[_player].name).length > 0, "Player not registered.");
        Player memory player = players[_player];
        return (player.name, player.points);
    }
}

