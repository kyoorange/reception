import React, { useState } from "react";
import RoomModal from "./RoomModal";

const RoomCard = ({ roomNumber, status, onStatusChange }) => {
    const [isModalOpen, setIsModalOpen] = useState(false);

    const toggleModal = () => {
        setIsModalOpen(!isModalOpen);
        if (!isModalOpen) {
            // モーダルを開くときは何もしない
        } else {
            // モーダルを閉じるときに状態を更新
            onStatusChange();
        }
    };

    // 状態に応じてCSSクラスを切り替える
    const getClassName = () => {
        switch (status) {
            case "in_use":
                return "room-card occupied"; // 占有中の場合のCSSクラス
            case "returned":
                return "room-card returned"; // 返却済みの場合のCSSクラス
            case null:
            case "available":
            default:
                return "room-card available"; // 空いている場合のCSSクラス
        }
    };

    return (
        <div className={getClassName()} onClick={toggleModal}>
            <div className="room-number">{roomNumber}</div>
            {isModalOpen && <RoomModal roomNumber={roomNumber} onClose={toggleModal} onStatusChange={onStatusChange} />}
        </div>
    );
};

export default RoomCard;
