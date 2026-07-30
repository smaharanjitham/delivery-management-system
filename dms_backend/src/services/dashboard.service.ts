import { Op } from "sequelize";

import DeliveryOrder from "../models/deliveryOrder.model";
import Customer from "../models/customer.model";

import {
  DashboardResponseDto,
} from "../dtos/dashboard.dto";

export class DashboardService {

  public async getDashboard(): Promise<DashboardResponseDto> {

    const pending = await DeliveryOrder.count({
      where: {
        status: "Pending",
      },
    });

    const delivered = await DeliveryOrder.count({
      where: {
        status: "Delivered",
      },
    });

    const cancelled = await DeliveryOrder.count({
      where: {
        status: "Cancelled",
      },
    });

    const today = await DeliveryOrder.count({
      where: {
        created_at: {
          [Op.gte]: new Date(
            new Date().setHours(0, 0, 0, 0)
          ),
        },
      },
    });

    const orders = await DeliveryOrder.findAll({

      include: [
        {
          model: Customer,
          as: "customer",
          attributes: [
            "customer_name",
          ],
        },
      ],

      order: [
        ["created_at", "DESC"],
      ],

      limit: 10,

    });

    return {

      success: true,

      message: "Dashboard loaded successfully",

      summary: {
        pending,
        delivered,
        today,
        cancelled,
      },

      recentOrders: orders.map((item: any) => ({
        id: item.id,
        order_number: item.order_number,
        customer_name: item.customer.customer_name,
        delivery_address: item.delivery_address,
        delivery_latitude: item.delivery_latitude,
        delivery_longitude: item.delivery_longitude,
        status: item.status,
      })),
    };
  }
}

export default new DashboardService();