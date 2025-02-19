import React, { useState, useEffect } from "react";
import RoomCard from "./RoomCard";

const App = () => {
    const mainHallRooms = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120];
    const focusRooms = [1, 2, 3, 4, 5, 6];
    const meetingRooms = [21, 22, 23, 24, 25, 26];
    const underRooms = [11, 12, 13, 14, 15, 16];
    const makersRooms = [31, 32, 33, 34];
    const terraceRooms = [41, 42, 43, 44];

    const [occupyStatuses, setOccupyStatuses] = useState({});

    const fetchOccupyStatuses = async () => {
        try {
            const response = await fetch("/api/v1/occupies/occupy_status");
            if (response.ok) {
                const data = await response.json();
                const statusMap = data.reduce((acc, item) => {
                    acc[item.room_number] = item.status;
                    return acc;
                }, {});
                setOccupyStatuses(statusMap);
            } else {
                console.error("Failed to fetch occupy statuses");
            }
        } catch (error) {
            console.error("Error fetching occupy statuses:", error);
        }
    };

    useEffect(() => {
        fetchOccupyStatuses();
    }, []);

    const handleRefresh = () => {
        fetchOccupyStatuses(); // リフレッシュボタンがクリックされたときに状態を再取得
    };

    return (
        <div className="main-content">
            <div className="left-container">
                <section className="section">
                    <h2>HALL</h2>
                    <button onClick={handleRefresh} className="refresh-button">リフレッシュ</button>
                    <div className="main-hall">
                        {mainHallRooms.map((roomNumber) => (
                            <RoomCard
                                key={roomNumber}
                                roomNumber={roomNumber}
                                status={occupyStatuses[roomNumber] || null}
                            />
                        ))}
                    </div>
                </section>
                <div className="horizontal-sections">
                    <section className="section">
                        <h2>INTENSIVE BOOTH</h2>
                        <div className="rooms-container">
                            {focusRooms.map((roomNumber) => (
                                <RoomCard
                                    key={roomNumber}
                                    roomNumber={roomNumber}
                                    status={occupyStatuses[roomNumber] || null}
                                />
                            ))}
                        </div>
                    </section>
                    <section className="section">
                        <h2>MTG ROOM</h2>
                        <div className="rooms-container">
                            {meetingRooms.map((roomNumber) => (
                                <RoomCard
                                    key={roomNumber}
                                    roomNumber={roomNumber}
                                    status={occupyStatuses[roomNumber] || null}
                                />
                            ))}
                        </div>
                    </section>
                    <section className="section">
                        <h2>UNDERGROUND SPACE</h2>
                        <div className="rooms-container">
                            {underRooms.map((roomNumber) => (
                                <RoomCard
                                    key={roomNumber}
                                    roomNumber={roomNumber}
                                    status={occupyStatuses[roomNumber] || null}
                                />
                            ))}
                        </div>
                    </section>
                </div>
            </div>
            <div className="right-container">
                <section className="section">
                    <h2>FAB SPACE</h2>
                    <div className="makers-container">
                        {makersRooms.map((roomNumber) => (
                            <RoomCard
                                key={roomNumber}
                                roomNumber={roomNumber}
                                status={occupyStatuses[roomNumber] || null}
                            />
                        ))}
                    </div>
                </section>
                <section className="section">
                    <h2>TERRACE</h2>
                    <div className="terrace-container">
                        {terraceRooms.map((roomNumber) => (
                            <RoomCard
                                key={roomNumber}
                                roomNumber={roomNumber}
                                status={occupyStatuses[roomNumber] || null}
                            />
                        ))}
                    </div>
                </section>
            </div>
        </div>
    );
};

export default App;
